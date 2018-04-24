class Admin::UsersController < Admin::BaseController

  def index
    @users = User.page(params[:page]).per(10).order("created_at DESC")

  end

  def update
    @user = User.find(params[:id])
    @user.role = params[:role]
    @user.save!
    flash[:notice] = "User role was successfully changed !"
    redirect_back(fallback_location: admin_users_path)
  end

end
