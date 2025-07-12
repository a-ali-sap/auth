class ParticipationSpacesController < ApplicationController
  before_action :set_organization
  before_action :set_participation_space, only: [:show, :edit, :update, :destroy]
  
  def index
    @participation_spaces = policy_scope(@organization.participation_spaces)
    @participation_spaces = @participation_spaces.includes(:creator, :participants)
  end
  
  def show
    authorize @participation_space
    @user_participation = current_user.participations.find_by(participation_space: @participation_space)
    @requires_parental_consent = current_user.minor? && @participation_space.requires_parental_consent?
    @parental_consent = current_user.parental_consents.find_by(participation_space: @participation_space)
  end
  
  def new
    @participation_space = @organization.participation_spaces.build
    authorize @participation_space
  end
  
  def create
    @participation_space = @organization.participation_spaces.build(participation_space_params)
    @participation_space.creator = current_user
    authorize @participation_space
    
    if @participation_space.save
      redirect_to [@organization, @participation_space], notice: 'Participation space was successfully created.'
    else
      render :new
    end
  end
  
  def update
    authorize @participation_space
    
    if @participation_space.update(participation_space_params)
      redirect_to [@organization, @participation_space], notice: 'Participation space was successfully updated.'
    else
      render :edit
    end
  end
  
  def destroy
    authorize @participation_space
    @participation_space.destroy
    redirect_to organization_participation_spaces_path(@organization), notice: 'Participation space was successfully deleted.'
  end
  
  private
  
  def set_organization
    @organization = Organization.find(params[:organization_id])
  end
  
  def set_participation_space
    @participation_space = @organization.participation_spaces.find(params[:id])
  end
  
  def participation_space_params
    permitted = params.require(:participation_space).permit(
      :name, :description, :participation_type, :max_participants,
      :start_date, :end_date, :status,
      allowed_age_groups: []
    )
    if permitted[:allowed_age_groups].is_a?(Array)
      permitted[:allowed_age_groups].reject!(&:blank?)
    end
    permitted
  end
end
