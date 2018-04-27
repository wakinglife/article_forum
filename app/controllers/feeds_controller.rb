class FeedsController < ApplicationController
  def index
    @user_count = User.all.count
    @post_count = Post.count
    @comment_count = Comment.all.count
    @users = User.order(comments_count: :desc).limit(10)
    @posts = Post.order(comments_count: :desc).limit(10)
  end
end
