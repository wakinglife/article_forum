class PostsController < ApplicationController
before_action :set_post, only:  [:show, :edit, :update, :destroy]

  def index
    @posts = Post.page(params[:page]).per(10).order(created_at: :desc)
    @categories = Category.all
  end

  def new
    @post = Post.new

  end

  def create
    @post = current_user.posts.build(post_params)
       if @post.save
         flash[:notice] = 'post was successfully created'
         redirect_to posts_path
       else
         flash[:alert] = @post.errors.full_messages.to_sentence
         @posts = Post.page(params[:page]).per(10).order(created_at: :desc)
         render :index
       end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new(comment: params[:comment])
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

  def destroy
    @post = Post.find(params[:post_id])

    if current_user.admin?
      @post.destroy
      redirect_to posts_path
    end
  end

  def feeds
      # @users = User.count
      # @posts = Post.count
      # @comments = Comment.count
      # @users = User.order(comments_count: :desc).limit(10)
      # @posts = Post.order(comments_count: :desc).limit(10)

  end

  def like
      @post = Post.find(params[:id])
      @post.likes.create!(user: current_user)
      likes_count
      redirect_back(fallback_location: root_path)
  end

  def unlike
      @post = Post.find(params[:id])
      like = Like.where(restaurant: @post, user: current_user)
      like.destroy_all
      likes_count
      redirect_back(fallback_location: root_path)
  end

private

  def set_post
    @post = Post.find(params[:id])
  end


  def post_params
    params.require(:post).permit(:content, :title, :image, :category_id)
  end

end
