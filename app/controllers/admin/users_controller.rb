class Admin::UsersController < Admin::BaseController

  def index
     # @users = User.page(params[:page]).per(30).order("posts_count DESC")
    @users = User.all
  end

end
