class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :comments, :collects, :friends]


    def show
      @posts = @user.posts
    end

    def edit
       unless @user == current_user
         redirect_to user_path(@user)
       end
    end

    def update
       if @user.update(user_params)
         redirect_to user_path(@user)
       else
         render :action => :edit
       end
    end

    def comments
      @comments = @user.comments.includes(:post)
    end

    def collects
      @collections = @user.collect_posts.includes(:collect_users)
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
