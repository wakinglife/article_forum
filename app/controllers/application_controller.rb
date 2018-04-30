class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!



private

    def after_sign_in_path_for(resource)
       posts_path
    end

    def configure_permitted_parameters
      #註冊頁面
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :avatar, :intro])
      #修改註冊資料
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :avatar, :description])
    end


end
