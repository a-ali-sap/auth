class ParticipationSpace < ApplicationRecord
  belongs_to :organization
  belongs_to :creator, class_name: 'User'
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user
  has_many :parental_consents, dependent: :destroy
  
  validates :name, presence: true
  validates :description, presence: true
  validates :allowed_age_groups, presence: true
  validates :max_participants, presence: true, numericality: { greater_than: 0 }
  
  enum :status, { draft: 0, active: 1, paused: 2, completed: 3, cancelled: 4 }
  enum :participation_type, { open: 0, moderated: 1, invitation_only: 2 }
  
  attribute :content_filters, :json, default: {}
  
  scope :active_spaces, -> { active }
  scope :for_age_group, ->(age_group) { where("allowed_age_groups @> ?", [age_group].to_json) }
  scope :with_available_spots, -> { where('current_participants < max_participants') }
  
  before_save :apply_age_appropriate_filters
  
  def available_spots
    max_participants - current_participants
  end
  
  def full?
    current_participants >= max_participants
  end
  
  def allows_age_group?(age_group)
    allowed_age_groups.include?(age_group.to_s)
  end
  
  def requires_parental_consent?
    allowed_age_groups.any? { |group| %w[child teen].include?(group) }
  end
  
  def user_can_participate?(user)
    return false unless active?
    return false if full?
    return false unless allows_age_group?(user.age_group)
    return false unless user.organization_member_of?(organization)
    return false if user.minor? && requires_parental_consent? && !user.parental_consent_given_for?(self)
    
    true
  end
  
  private
  
  def apply_age_appropriate_filters
    self.content_filters ||= {}
    
    if allowed_age_groups.include?('child')
      self.content_filters.merge!(
        profanity_filter: true,
        strict_moderation: true,
        external_links_blocked: true
      )
    elsif allowed_age_groups.include?('teen')
      self.content_filters.merge!(
        profanity_filter: true,
        moderate_moderation: true
      )
    end
  end
end
