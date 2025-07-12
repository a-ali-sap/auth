class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :owned_organizations, class_name: 'Organization', foreign_key: 'owner_id'
  has_many :participations, dependent: :destroy
  has_one :age_verification, dependent: :destroy
  has_many :parental_consents, dependent: :destroy
  
  validates :first_name, :last_name, presence: true
  validates :date_of_birth, presence: true
  validate :validate_age_requirements
  
  enum :status, { pending: 0, active: 1, suspended: 2, banned: 3 }

  scope :adults, -> { where('date_of_birth <= ?', 18.years.ago) }
  scope :minors, -> { where('date_of_birth > ?', 18.years.ago) }
  scope :by_age_group, ->(group) { where(age_group: group) }
  
  before_create :set_age_group
  after_create :create_age_verification_if_needed
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def age
    return nil unless date_of_birth
    ((Time.current - date_of_birth.to_time) / 1.year.seconds).floor
  end
  
  def minor?
    age && age < 18
  end
  
  def adult?
    !minor?
  end
  
  def age_verified?
    age_verification&.verified?
  end
  
  def can_participate_in?(participation_space)
    return false unless active?
    return false if minor? && !parental_consent_given_for?(participation_space)
    return false unless age_group_allowed_for?(participation_space)
    return false unless organization_member_of?(participation_space.organization)
    
    true
  end
  
  def organization_role_in(organization)
    organization_memberships.find_by(organization: organization)&.role
  end
  
  private
  
  def validate_age_requirements
    if date_of_birth && date_of_birth > Date.current
      errors.add(:date_of_birth, "cannot be in the future")
    end
    
    if date_of_birth && age && age > 120
      errors.add(:date_of_birth, "seems unrealistic")
    end
  end
  
  def set_age_group
    return unless date_of_birth
    
    case age
    when 0..12
      self.age_group = 'child'
    when 13..17
      self.age_group = 'teen'
    when 18..64
      self.age_group = 'adult'
    else
      self.age_group = 'senior'
    end
  end
  
  def create_age_verification_if_needed
    AgeVerificationService.new(self).create_if_needed
  end
  
  def parental_consent_given_for?(participation_space)
    return true if adult?
    
    parental_consents.approved.exists?(
      participation_space: participation_space
    )
  end
  
  def age_group_allowed_for?(participation_space)
    participation_space.allowed_age_groups.include?(age_group)
  end
  
  def organization_member_of?(organization)
    organization_memberships.approved.exists?(organization: organization)
  end
end
