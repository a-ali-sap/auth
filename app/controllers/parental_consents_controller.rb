class ParentalConsentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :update]
  before_action :set_parental_consent, only: [:show, :update]
  
  def new
    @participation_space = ParticipationSpace.find(params[:participation_space_id])
    @parental_consent = current_user.parental_consents.build(participation_space: @participation_space)
    
    redirect_to root_path, alert: 'Parental consent not required.' if current_user.adult?
  end
  
  def create
    @participation_space = ParticipationSpace.find(params[:participation_space_id])
    
    service = ParentalConsentService.new(current_user, @participation_space)
    @parental_consent = service.request_consent(parental_consent_params)
    
    if @parental_consent.persisted?
      redirect_to @parental_consent, notice: 'Parental consent request sent successfully.'
    else
      render :new
    end
  end
  
  def show
    # This is accessed by parents via email link
  end
  
  def update
    # Parent's response to consent request
    decision = params[:decision]
    verification_code = params[:verification_code]
    
    service = ParentalConsentService.new(@parental_consent.user, @parental_consent.participation_space)
    
    if service.process_consent_response(@parental_consent.id, decision, verification_code)
      render :consent_approved
    else
      render :consent_rejected
    end
  end
  
  private
  
  def set_parental_consent
    @parental_consent = ParentalConsent.find(params[:id])
  end
  
  def parental_consent_params
    params.require(:parental_consent).permit(
      :parent_name, :parent_email, :parent_phone, :relationship, :consent_method
    ).to_h.symbolize_keys
  end
end
