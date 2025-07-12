class ParticipationsController < ApplicationController
  before_action :set_organization
  before_action :set_participation_space

  def create
    @participation = @participation_space.participations.build(user: current_user)
    authorize @participation if respond_to?(:authorize)

    if @participation.save
      redirect_to [@organization, @participation_space], notice: 'You have joined the participation space.'
    else
      redirect_to [@organization, @participation_space], alert: 'Could not join participation space.'
    end
  end

  private

  def set_organization
    @organization = Organization.find(params[:organization_id])
  end

  def set_participation_space
    @participation_space = @organization.participation_spaces.find(params[:participation_space_id])
  end
end
