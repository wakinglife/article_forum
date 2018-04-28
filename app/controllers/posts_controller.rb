class PostsController < ApplicationController
before_action :set_post, only:  [:show, :edit, :update, :destroy, :collect, :uncollect]

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
    @comment = Comment.new(comment: params[:comment])
    @comments = @post.comments.page(params[:page]).per(20)
  end

  def edit
    unless @user == current_user
      redirect_to post_path(@post)
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
    if current_user.admin?
      @post.destroy
      redirect_to posts_path
    end
  end

  def collect
    @post.collects.create!(user: current_user)
    redirect_back(fallback_location: root_path)
    respond_to do |format|
    format.js
    end
  end

  def uncollect
    collect = Collect.find_by(user: current_user)
    collect.destroy
    redirect_back(fallback_location: root_path)
    respond_to do |format|
    format.js
    end
  end

private

  def set_post
    @post = Post.find(params[:id])
  end


  def post_params
    params.require(:post).permit(:content, :title, :image, :category_id)
  end

end
