class Admin::BaseController < ApplicationController

  before_action :authenticate_admin
  before_action :authenticate_user!
    # layout "dashboard"

  private

     def authenticate_admin
       unless current_user.admin?
         flash[:alert] = "Admin Only!"
         redirect_to root_path
       end
     end
end
