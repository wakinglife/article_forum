class Admin::UsersController < Admin::BaseController

  def index
    @users = User.page(params[:page]).per(10).order("created_at DESC")
    # @users = User.all

  end

  def toggle_admin
    params[:user_ids] = params[:user_ids].map{|i| i.to_i}
    @users = User.find(params[:user_ids])
    @users.each do |user|
      user.toggle_admin!
      user.save
    end
    redirect_to admin_users_path
  end

end
