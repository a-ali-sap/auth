class Participation < ApplicationRecord
  belongs_to :user
  belongs_to :participation_space
  
  validates :user_id, uniqueness: { scope: :participation_space_id }
  
  enum :status, { active: 0, paused: 1, completed: 2, removed: 3 }
  
  scope :active_participations, -> { active }
  
  after_create :increment_participant_count
  after_destroy :decrement_participant_count
  after_create :log_participation_event
  
  private
  
  def increment_participant_count
    participation_space.increment!(:current_participants)
  end
  
  def decrement_participant_count
    participation_space.decrement!(:current_participants)
  end
  
  def log_participation_event
    Rails.logger.info("User \\#{user_id} joined ParticipationSpace \\#{participation_space_id}")
  end
end
