class AgeVerificationsController < ApplicationController
  before_action :set_age_verification, only: [:show, :update]
  
  def new
    redirect_to root_path, alert: 'Age verification not required.' if current_user.adult?
    @age_verification = AgeVerification.new
  end

  def create
    @age_verification = current_user.build_age_verification(age_verification_params)
    if @age_verification.save
      redirect_to @age_verification, notice: 'Document uploaded successfully. Verification pending.'
    else
      render :new
    end
  end
  
  def show
    redirect_to root_path unless @age_verification.user == current_user
  end

  def update
    if @age_verification.update(age_verification_params)
      redirect_to @age_verification, notice: 'Age verification updated successfully.'
    else
      render :edit
    end
  end
  
  private
  
  def set_age_verification
    @age_verification = AgeVerification.find(params[:id])
  end
  
  def age_verification_params
    params.require(:age_verification).permit(:document, :verification_method)
  end
end
