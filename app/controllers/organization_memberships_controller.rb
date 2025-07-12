
class OrganizationMembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_membership, only: []

  def create
    authorize @organization, :join?
    membership = @organization.organization_memberships.build(
      user: current_user,
      role: :member,
      status: @organization.is_public? ? :approved : :pending
    )
    if membership.save
      message = @organization.is_public? ? 'Successfully joined organization!' : 'Membership request sent!'
      redirect_to @organization, notice: message
    else
      redirect_to @organization, alert: 'Unable to join organization.'
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_membership
    @membership = @organization.organization_memberships.find(params[:id])
  end
end
