class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  
  def index
    if user_signed_in?
      redirect_to authenticated_root_path
    else
      @public_organizations = Organization.public_organizations
                                         .active
                                         .includes(:owner)
                                         .limit(6)
    end
  end
end
