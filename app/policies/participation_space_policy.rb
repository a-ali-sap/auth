class ParticipationSpacePolicy < ApplicationPolicy
  def index?
    user_is_organization_member?
  end
  
  def show?
    user_is_organization_member?
  end
  
  def create?
    return false unless user&.active?
    
    membership = user.organization_memberships.approved.find_by(organization: record.organization)
    membership&.can_create_participation_spaces?
  end
  
  def update?
    return true if record.creator == user
    return true if user_is_organization_admin?
    
    false
  end
  
  def destroy?
    return true if record.creator == user
    return true if user_is_organization_admin?
    
    false
  end
  
  def participate?
    return false unless user&.active?
    
    record.user_can_participate?(user)
  end
  
  def manage_participants?
    return true if record.creator == user
    return true if user_is_organization_admin?
    
    membership = user.organization_memberships.approved.find_by(organization: record.organization)
    membership&.can_approve_participations?
  end
  
  private
  
  def user_is_organization_member?
    return false unless user
    
    user.organization_memberships.approved.exists?(organization: record.organization)
  end
  
  def user_is_organization_admin?
    return false unless user
    
    membership = user.organization_memberships.approved.find_by(organization: record.organization)
    membership&.admin? || membership&.owner?
  end
  
  class Scope < Scope
    def resolve
      return scope.none unless user
      
      # Show spaces from organizations user is a member of
      organization_ids = user.organization_memberships.approved.pluck(:organization_id)
      scope.where(organization_id: organization_ids)
    end
  end
end
