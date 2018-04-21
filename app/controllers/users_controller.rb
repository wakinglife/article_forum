class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :friend_list]




    def show
      @posts = @user.posts.uniq
      # @commented_posts = @user.posts.uniq
      #
      # @liked_posts = @user.posts.uniq
      # @friends = @user.friends.uniq

    end

    def edit

       unless @user == current_user
         redirect_to user_path(@user)
       end
    end


    def update

       if @user.update_attributes(user_params)
         redirect_to user_path(@user)
       else
         render :action => :edit
       end
    end


    def friend_list

      @friends = @user.all_friends.uniq
    end



    private

       def set_user
        @user = User.find(params[:id])
       end

       def user_params
         params.require(:user).permit(:name, :intro, :avatar)
       end


end
