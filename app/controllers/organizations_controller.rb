class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :join, :leave, :analytics, :update, :destroy]
  
  def index
    @organizations = policy_scope(Organization).includes(:owner, :organization_memberships)
    @organizations = @organizations.page(params[:page]).per(10)
  end
  
  def show
    authorize @organization
    @membership = current_user.organization_memberships.find_by(organization: @organization)
    @participation_spaces = policy_scope(@organization.participation_spaces.active)
  end
  
  def new
    @organization = Organization.new
    authorize @organization
  end
  
  def create
    @organization = current_user.owned_organizations.build(organization_params)
    authorize @organization
    
    if @organization.save
      # Create owner membership
      @organization.organization_memberships.create!(
        user: current_user,
        role: :owner,
        status: :approved
      )
      
      redirect_to @organization, notice: 'Organization was successfully created.'
    else
      render :new
    end
  end
  
  def update
    authorize @organization
    
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organization was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    authorize @organization
    @organization.destroy
    redirect_to organizations_path, notice: 'Organization was successfully deleted.'
  end
  
  def join
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
  
  def leave
    authorize @organization, :leave?
    
    membership = current_user.organization_memberships.find_by(organization: @organization)
    membership&.destroy
    
    redirect_to organizations_path, notice: 'Successfully left organization.'
  end
  
  def analytics
    authorize @organization, :analytics?
    @analytics = @organization.analytics_data
  end
  
  private
  
  def set_organization
    @organization = Organization.find(params[:id])
  end
  
  def organization_params
    params.require(:organization).permit(
      :name, :description, :organization_type, :is_public, :website_url,
      :contact_email, :phone_number, :address
    )
  end
end
