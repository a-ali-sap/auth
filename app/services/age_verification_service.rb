class AgeVerificationService
  def initialize(user)
    @user = user
  end
  
  def create_if_needed
    return if @user.adult?
    return if @user.age_verification.present?
    
    @user.create_age_verification!(
      verification_method: :document_upload,
      verification_status: :pending
    )
  end
  
  def verify_document(verification_id, admin_user)
    verification = AgeVerification.find(verification_id)
    
    return false unless verification.can_be_verified?
    
    result = DocumentVerificationService.new(verification.document).verify
    
    if result[:valid]
      verification.update!(
        verification_status: :verified,
        verified_at: Time.current,
        verified_by: admin_user,
        verification_notes: result[:notes]
      )
      true
    else
      verification.update!(
        verification_status: :rejected,
        verification_notes: result[:errors].join(', ')
      )
      false
    end
  end
  
  def check_expiration
    expired_verifications = AgeVerification.verified.where(
      'verified_at < ?', 1.year.ago
    )
    
    expired_verifications.update_all(verification_status: :expired)
  end
end
