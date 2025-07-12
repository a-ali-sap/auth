class AgeVerification < ApplicationRecord
  belongs_to :user
  
  validates :verification_method, presence: true
  validates :verification_status, presence: true
  
  enum :verification_method, { 
    document_upload: 0, 
    credit_card: 1, 
    phone_verification: 2,
    third_party_service: 3
  }
  
  enum :verification_status, { pending: 0, verified: 1, rejected: 2, expired: 3 }
  
  mount_uploader :document
  
  scope :verified_users, -> { verified }
  scope :pending_verification, -> { pending }
  
  after_update :notify_user_of_verification_result
  
  def expired?
    verified? && verified_at && verified_at < 1.year.ago
  end
  
  def can_be_verified?
    pending? && document.present?
  end
  
  private
  
  def notify_user_of_verification_result
    if saved_change_to_verification_status?
      UserMailer.age_verification_result(self).deliver_later
    end
  end
end
