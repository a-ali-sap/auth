class DashboardController < ApplicationController
  before_action :ensure_user_authenticated
  
  def index
    @user_organizations = current_user.organizations.includes(:owner, :organization_memberships)
    @recent_participations = current_user.participations
                                        .includes(:participation_space => :organization)
                                        .order(created_at: :desc)
                                        .limit(5)
    @pending_consents = current_user.parental_consents.pending.includes(:participation_space)
    @age_verification = current_user.age_verification
    
    # Statistics for dashboard cards
    @stats = {
      organizations_count: @user_organizations.count,
      active_participations: current_user.participations.active.count,
      pending_requests: current_user.organization_memberships.pending.count,
      completed_participations: current_user.participations.completed.count
    }
  end
  
  private
  
  def ensure_user_authenticated
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to access your dashboard."
      return
    end
    
    unless current_user
      redirect_to new_user_session_path, alert: "Session expired. Please sign in again."
      return
    end
  end
end
