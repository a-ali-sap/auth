class OrganizationPolicy < ApplicationPolicy
  def index?
    true
  end
  
  def show?
    return true if record.is_public?
    return true if user&.organization_memberships&.approved&.exists?(organization: record)
    
    false
  end
  
  def create?
    user&.active?
  end
  
  def update?
    return true if record.owner == user
    return true if user_is_admin?
    
    false
  end
  
  def destroy?
    record.owner == user
  end
  
  def join?
    return false unless user&.active?
    return false if user.organization_memberships.exists?(organization: record)
    
    record.can_user_join?(user)
  end
  
  def leave?
    return false if record.owner == user
    
    user.organization_memberships.approved.exists?(organization: record)
  end
  
  def analytics?
    return true if record.owner == user
    return true if user_is_admin?
    
    false
  end
  
  def manage_members?
    return true if record.owner == user
    return true if user_is_admin?
    
    false
  end
  
  private
  
  def user_is_admin?
    return false unless user
    
    membership = user.organization_memberships.approved.find_by(organization: record)
    membership&.admin? || membership&.owner?
  end
  
  class Scope < Scope
    def resolve
      if user
        # Show public organizations and organizations user is a member of
        scope.left_joins(:organization_memberships)
             .where(
               'organizations.is_public = ? OR (organization_memberships.user_id = ? AND organization_memberships.status = ?)',
               true, user.id, OrganizationMembership.statuses[:approved]
             )
             .distinct
      else
        scope.public_organizations
      end
    end
  end
end
