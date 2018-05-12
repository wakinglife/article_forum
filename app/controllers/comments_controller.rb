class CommentsController < ApplicationController
  before_action :set_post, only: [:create, :edit, :update, :destroy, :check_comment_author]
  before_action :set_comment, only: [:edit, :update, :destroy, :check_comment_author]
  before_action :check_comment_author, only: [:edit, :update, :destroy]


    def create
       @comment = @post.comments.build(comment_params)
       @comment.user = current_user
      if @comment.save
        flash[:notice] = "Comment was created."
        redirect_back(fallback_location: post_path(@post))
      else
        flash.now[:alert] = @comment.errors.full_messages.each{|msg| msg.class}
        redirect_back(fallback_location: post_path(@post, comment_params))
      end
    end

    def edit

    end

    def update
      @comment.update(comment_params)
      flash[:notice] = "comment was updated."
      redirect_back(fallback_location: post_path(@comment.post_id))
    end

    def destroy
      @comment.destroy
      redirect_back(fallback_location: post_path(@post))
    end

private

    def set_post
    @post = Post.find(params[:post_id])
    end

    def set_comment
    @comment = Comment.find(params[:id])
    end

    def comment_params
    params.require(:comment).permit(:content)
    end

    def check_comment_author
      unless @comment.user == current_user || current_user.admin?
        flash[:alert] = "You can only edit and delete your comments！"
        redirect_to post_path(@post)
      end
    end



end
