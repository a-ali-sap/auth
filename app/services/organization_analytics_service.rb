class OrganizationAnalyticsService
  def initialize(organization)
    @organization = organization
  end
  
  def generate_report
    {
      membership_stats: membership_statistics,
      participation_stats: participation_statistics,
      age_demographics: age_demographics,
      activity_trends: activity_trends,
      engagement_metrics: engagement_metrics
    }
  end
  
  private
  
  def membership_statistics
    memberships = @organization.organization_memberships
    
    {
      total_members: memberships.approved.count,
      pending_requests: memberships.pending.count,
      members_by_role: memberships.approved.group(:role).count,
      recent_joins: memberships.approved.where('created_at > ?', 30.days.ago).count
    }
  end
  
  def participation_statistics
    spaces = @organization.participation_spaces
    participations = @organization.participations
    
    {
      total_spaces: spaces.count,
      active_spaces: spaces.active.count,
      total_participations: participations.count,
      average_participants_per_space: participations.count.to_f / spaces.count,
      completion_rate: calculate_completion_rate
    }
  end
  
  def age_demographics
    members = @organization.members.approved
    
    {
      by_age_group: members.group(:age_group).count,
      average_age: members.average('EXTRACT(YEAR FROM AGE(date_of_birth))'),
      minors_count: members.where('date_of_birth > ?', 18.years.ago).count,
      adults_count: members.where('date_of_birth <= ?', 18.years.ago).count
    }
  end
  
  def activity_trends
    last_30_days = 30.days.ago..Time.current
    
    {
      daily_participations: @organization.participations
        .where(created_at: last_30_days)
        .group_by_day(:created_at)
        .count,
      weekly_new_members: @organization.organization_memberships
        .approved
        .where(created_at: last_30_days)
        .group_by_week(:created_at)
        .count
    }
  end
  
  def engagement_metrics
    {
      active_participants_last_week: active_participants_count(1.week.ago),
      active_participants_last_month: active_participants_count(1.month.ago),
      retention_rate: calculate_retention_rate,
      most_popular_spaces: most_popular_spaces
    }
  end
  
  def calculate_completion_rate
    completed = @organization.participations.completed.count
    total = @organization.participations.count
    return 0 if total.zero?
    
    (completed.to_f / total * 100).round(2)
  end
  
  def active_participants_count(since)
    @organization.participations
      .where('updated_at > ?', since)
      .distinct
      .count(:user_id)
  end
  
  def calculate_retention_rate
    # Users who joined more than 30 days ago and are still active
    old_members = @organization.organization_memberships
      .approved
      .where('created_at < ?', 30.days.ago)
    
    active_old_members = old_members
      .joins(:user)
      .where(users: { status: :active })
    
    return 0 if old_members.count.zero?
    
    (active_old_members.count.to_f / old_members.count * 100).round(2)
  end
  
  def most_popular_spaces
    @organization.participation_spaces
      .joins(:participations)
      .group('participation_spaces.name')
      .order('COUNT(participations.id) DESC')
      .limit(5)
      .count
  end
end
