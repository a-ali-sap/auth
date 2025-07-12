class OrganizationMembership < ApplicationRecord
  belongs_to :user
  belongs_to :organization
  
  validates :user_id, uniqueness: { scope: :organization_id }
  validates :role, presence: true
  
  enum :status, { pending: 0, approved: 1, rejected: 2, suspended: 3 }
  enum :role, { member: 0, moderator: 1, admin: 2, owner: 3 }
  
  scope :active_members, -> { approved }
  scope :by_role, ->(role) { where(role: role) }
  
  after_create :notify_organization_admins
  after_update :notify_user_of_status_change
  
  def can_manage_members?
    admin? || owner?
  end
  
  def can_create_participation_spaces?
    moderator? || admin? || owner?
  end
  
  def can_approve_participations?
    moderator? || admin? || owner?
  end
  
  private
  
  def notify_organization_admins
    OrganizationMailer.new_membership_request(self).deliver_later if pending?
  end
  
  def notify_user_of_status_change
    if saved_change_to_status?
      UserMailer.membership_status_changed(self).deliver_later
    end
  end
end
