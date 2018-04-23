class PostsController < ApplicationController


  def index
    # @users = User.order(created_at: :desc).limit(10)

    # @posts = Post.new
    @posts = Post.page(params[:page]).per(10).order(created_at: :desc)

  end



  def create
    @posts = Post.new
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


  def edit
     unless @user == current_user
       redirect_to posts_user_path(@user)
     end
  end

  def update

    if @post.update(post_params)
      flash[:notice] = "post was updated"
      redirect_to posts_user_path(@user)
    else
      render :action => :edit
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
