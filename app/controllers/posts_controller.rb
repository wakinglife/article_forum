class PostsController < ApplicationController
before_action :set_post, only:  [:show, :edit, :update, :destroy, :collect, :uncollect, :check_author]
before_action :check_author, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
    if current_user
      if params[:category_id]
        @category = Category.find(params[:category_id])
        @ransack = @category.posts.readable_posts(current_user).open_public.ransack(params[:q])
      else
        @ransack = Post.readable_posts(current_user).open_public.ransack(params[:q])
      end
    else
      if params[:category_id]
        @category = Category.find(params[:category_id])
        @ransack = @category.posts.open_public.where(authority: "all").ransack(params[:q])
      else
        @ransack = Post.open_public.where(authority: "all").ransack(params[:q])
      end
    end
      @posts = @ransack.result(distinct: true).includes(:comments).page(params[:page]).per(20)
   end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:commit] == "Save Draft"
      @post.public = false
      if @post.save
        redirect_to drafts_user_path(current_user)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    else
      @post.public = true
      if @post.save
        redirect_to post_path(@post)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    end
  end

  def show
    if @post.check_authority_for?(current_user)

      @comments = @post.comments.includes(:user).page(params[:page]).per(20)
      @comment = Comment.new
    else
      flash[:alert] = "You have no authority"
      redirect_to posts_path
    end
  end

  def edit
   
  end

  def update
    if params[:commit] == "Save Draft"
      @post.public = false
      if @post.update(post_params)
        flash[:notice] = "儲存草稿"
        redirect_to drafts_user_path(current_user)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :edit
      end
    else
      @post.public = true
      if @post.update(post_params)
        flash[:notice] = "Post published"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    if @post.public
      @post.destroy
      flash[:notice] = "Post was deleted successfully"
      redirect_to posts_path
    else
      @post.destroy
      flash[:notice] = "Draft was deleted successfully"
      redirect_to drafts_user_path(current_user)
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
      params.require(:post).permit(:content, :title, :image, :public, :authority, category_ids: [])
    end

    def check_author
      unless @post.user == current_user || current_user.admin?
        flash[:alert] = "You have no authority！"
        redirect_to post_path(@post)
      end
    end
end
