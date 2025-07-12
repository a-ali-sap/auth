class ApplicationController < ActionController::Base
  include Pundit::Authorization
  
  protect_from_forgery with: :exception
before_action :authenticate_user! # Require authentication for all actions by default
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :first_name, :last_name, :date_of_birth, :phone_number
    ])
    
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name, :last_name, :phone_number
    ])
  end
  
  # Override Devise's after_sign_in_path to redirect to dashboard
  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end
  
  # Override Devise's after_sign_out_path
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  
  private
  
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
