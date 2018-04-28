class CommentsController < ApplicationController
  before_action :set_comment, only:  [:edit, :update, :destroy]


  def create
       @post = Post.find(params[:post_id])
       @comment = @post.comments.build(comment_params)
       @comment.user = current_user

      if @comment.save
        flash[:notice]= "Message saved"
        redirect_back(fallback_location: post_path(@post))
      else
        flash.now[:alert]= @comment.errors.full_messages.each{|msg| msg.class}
        @post = Post.find(params[:post_id])
        redirect_back(fallback_location: post_path(@post, comment_params))
      end

    end

    def edit

    end

    def update
        @comment.update(comment_params)
        flash[:notice] = "comment was updated"
        redirect_to post_path(@comment.post_id)
    end

    def destroy
        @post = Post.find(params[:post_id])
        @comment.destroy
        redirect_back(fallback_location: post_path(@post))
      end

private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:comment, :post_id, :user_id)
    end

end
