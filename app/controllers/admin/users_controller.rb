class Admin::UsersController < Admin::BaseController

  def index
     # @users = User.page(params[:page]).per(30).order("posts_count DESC")
    @users = User.all
  end


  private

     def set_user
        @user = User.find(params[:id])
      end

     def user_params
       params.require(:user).permit(:name, :intro, :avatar)
     end

end
