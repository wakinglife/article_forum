class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # @users = User.order(created_at: :desc).limit(10)
    @posts = Post.all
    # @posts = Post.new
    # @posts = Post.page(params[:page]).per(20).order(created_at: :desc)

  end



  def create

    @post = current_user.posts.build(post_params)
       if @post.save
         flash[:notice] = 'post was successfully created'
         redirect_to posts_path
       else
         flash[:alert] = @post.errors.full_messages.to_sentence
         @posts = Post.page(params[:page]).per(20).order(created_at: :desc)
         render :index
       end
  end

  private

def set_post
   @post = Post.find(params[:id])
end


def post_params
  params.require(:post).permit(:content)
end

end
