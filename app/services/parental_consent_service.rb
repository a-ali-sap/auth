class ParentalConsentService
  def initialize(user, participation_space)
    @user = user
    @participation_space = participation_space
  end
  
  def request_consent(parent_info)
    consent = ParentalConsent.create!(
      user: @user,
      participation_space: @participation_space,
      parent_name: parent_info[:name],
      parent_email: parent_info[:email],
      parent_phone: parent_info[:phone],
      relationship: parent_info[:relationship],
      consent_method: parent_info[:method] || :email
    )
    
    send_consent_request(consent)
    consent
  end
  
  def process_consent_response(consent_id, decision, verification_code)
    consent = ParentalConsent.find(consent_id)
    
    return false unless verify_consent_code(consent, verification_code)
    
    if decision == 'approve'
      consent.update!(
        status: :approved,
        approved_at: Time.current,
        consent_given_at: Time.current
      )
      
      # Allow user to participate
      create_participation_if_eligible(consent)
      true
    else
      consent.update!(
        status: :rejected,
        rejection_reason: 'Parent declined consent'
      )
      false
    end
  end
  
  def check_expired_consents
    expired_consents = ParentalConsent.approved.where(
      'expires_at < ?', Time.current
    )
    
    expired_consents.update_all(status: :expired)
    
    # Remove participations for expired consents
    expired_consents.each do |consent|
      remove_participation_for_expired_consent(consent)
    end
  end
  
  private
  
  def send_consent_request(consent)
    # Generate secure verification code
    consent.update!(verification_code: SecureRandom.hex(16))
    
    case consent.consent_method.to_sym
    when :email
      ParentalConsentMailer.email_consent_request(consent).deliver_now
    when :phone
      SmsService.send_consent_request(consent)
    end
  end
  
  def verify_consent_code(consent, provided_code)
    consent.verification_code == provided_code
  end
  
  def create_participation_if_eligible(consent)
    return unless consent.participation_space.user_can_participate?(consent.user)
    
    Participation.create!(
      user: consent.user,
      participation_space: consent.participation_space
    )
  end
  
  def remove_participation_for_expired_consent(consent)
    participation = Participation.find_by(
      user: consent.user,
      participation_space: consent.participation_space
    )
    
    participation&.destroy
  end
end
