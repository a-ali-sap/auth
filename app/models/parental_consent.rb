class ParentalConsent < ApplicationRecord
  belongs_to :user # The minor
  belongs_to :participation_space
  
  validates :parent_name, presence: true
  validates :parent_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :parent_phone, presence: true
  validates :relationship, presence: true
  
  enum :status, { pending: 0, approved: 1, rejected: 2, expired: 3 }
  enum :consent_method, { email: 0, phone: 1, in_person: 2, digital_signature: 3 }
  
  scope :active_consents, -> { approved.where('expires_at > ?', Time.current) }
  
  before_create :set_expiration_date
  after_create :send_consent_request
  after_update :notify_parties_of_decision
  
  def expired?
    expires_at && expires_at < Time.current
  end
  
  def valid_consent?
    approved? && !expired?
  end
  
  private
  
  def set_expiration_date
    self.expires_at = 1.year.from_now
  end
  
  def send_consent_request
    ParentalConsentMailer.consent_request(self).deliver_later
  end
  
  def notify_parties_of_decision
    if saved_change_to_status? && !pending?
      ParentalConsentMailer.consent_decision(self).deliver_later
      UserMailer.parental_consent_update(self).deliver_later
    end
  end
end
