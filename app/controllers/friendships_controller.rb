class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.unconfirm_friendships.build(friend_id: params[:friend_id])
    if @friendship.save
      flash[:notice] = "Successfully send friend request!"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
    @user = User.find(params[:friend_id])
    respond_to do |format|
      format.js
    end
  end

  def accept
    @friendship = current_user.request_friendships.find_by(user_id: params[:id])
    @friendship.update(status: true)
    flash[:notice] = "Successfully add new friend!"
    @user = User.find(params[:id])
    redirect_back(fallback_location: root_path)
    respond_to do |format|
      format.js
    end
  end

  def ignore
    @friendship = current_user.request_friendships.find_by(user_id: params[:id])
    @friendship.destroy
    flash[:alert] = "Friend request has been ignored!"
    @user = User.find(params[:id])
    redirect_back(fallback_location: root_path)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    Friendship.where(user_id: params[:user_id], friend_id: current_user.id).destroy_all
    Friendship.where(user_id: current_user.id, friend_id: params[:user_id]).destroy_all
      #unfriend from self profile
    if @friend = User.find(params[:user_id])
      respond_to do |format|
      format.js
      end
    else
      #unfriend from other users profile
      flash[:notice] = "Successfully remove friend!"
      redirect_back(fallback_location: root_path)
    end
  end

end
