class Organization < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :organization_memberships, dependent: :destroy
  has_many :members, through: :organization_memberships, source: :user
  has_many :participation_spaces, dependent: :destroy
  has_many :participations, through: :participation_spaces
  
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :organization_type, presence: true
  
  enum :status, { active: 0, inactive: 1, suspended: 2 }
  enum :organization_type, { 
    corporate: 0, 
    educational: 1, 
    non_profit: 2, 
    government: 3,
    community: 4
  }
  
  scope :public_organizations, -> { where(is_public: true) }
  scope :private_organizations, -> { where(is_public: false) }
  
  def admin_members
    organization_memberships.where(role: 'admin').includes(:user)
  end
  
  def pending_memberships
    organization_memberships.pending
  end
  
  def total_participations
    participations.count
  end
  
  def analytics_data
    OrganizationAnalyticsService.new(self).generate_report
  end
  
  def can_user_join?(user)
    return false unless active?
    return false if organization_memberships.exists?(user: user)
    return true if is_public?
    
    # Private organizations require invitation or approval
    false
  end
end
