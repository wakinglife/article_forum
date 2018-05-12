class PostsController < ApplicationController
before_action :set_post, only: [:show, :edit, :update, :destroy, :collect, :uncollect, :check_author]
before_action :check_author, only: [:edit, :update, :destroy]
before_action :authenticate_user!, except: :index
impressionist :actions => [:show]

  def index
    @categories = Category.all
    if params[:category_id].present?
      @category = Category.find_by_id(params[:category_id])
      @ransack = Post.includes(:comments, :categories).where(draft: false, categories: {id: params[:category_id]}).ransack(params[:q])
    else
      @ransack = Post.includes(:comments).where(draft: false).ransack(params[:q])
    end
    @posts = @ransack.result(distinct: true).includes(:comments).order(:id).page(params[:page]).per(20)
    check_posts_authority
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if params[:commit] == 'Save Draft'
      @post.draft = true
      if @post.save
        flash[:notice] = "Draft was successfully saved."
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "Draft was failed to saved. #{@post.errors.full_messages.to_sentence}"
        render :new
      end
    else
      @post.draft = false
      if @post.save
        flash[:notice] = "Post was successfully created."
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "Post was failed to created. #{@post.errors.full_messages.to_sentence}"
        render :new
      end
    end
  end

  def show
    if current_user.role != "admin"
      if @post.user != current_user
        if @post.authority == 'friend' && !(current_user.friend?(@post.user))
          flash[:alert] = "You have no authority."
          redirect_back(fallback_location: root_path)
        elsif @post.authority == 'myself'
          flash[:alert] = "You have no authority."
          redirect_back(fallback_location: root_path)
        elsif @post.draft == true
          flash[:alert] = "You have no authority."
          redirect_back(fallback_location: root_path)
        end
      end
    else
      if @post.authority == 'myself' && current_user != @post.user
        flash[:alert] = "You have no authority."
        redirect_back(fallback_location: root_path)
      elsif @post.draft == true && current_user != @post.user
        flash[:alert] = "You have no authority."
        redirect_back(fallback_location: root_path)
      end
    end

    @comment = Comment.new
    @comments = @post.comments.includes(:user).page(params[:page]).per(20)
    @user = @post.user
    @post.update(viewed_count: @post.impressionist_count)
    # @post.update(viewed_count: @post.impressionist_count(:filter=>:session_hash))
  end


  def edit

  end

  def update
    if params[:commit] == "Save Draft"
      @post.draft = true
      if @post.update(post_params)
        flash[:notice] = "Draft was successfully saved."
        redirect_to drafts_user_path(current_user)
      else
        flash.now[:alert] = "Draft was failed to saved. #{@post.errors.full_messages.to_sentence}"
        render :new
      end
    else
      @post.draft = false
      if @post.update(post_params)
        flash[:notice] = "Post published"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = "Post was failed to created. #{@post.errors.full_messages.to_sentence}"
        render :new
      end
    end

    if !@post.update(post_params)
      flash[:alert] = "Post was failed to update. #{@post.errors.full_messages.to_sentence}"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "Post was deleted successfully"
    redirect_to posts_path
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
      params.require(:post).permit(:content, :title, :image, :public, :authority, :category_ids => [])
    end

    def check_author
      unless @post.user == current_user || current_user.admin?
        flash[:alert] = "You have no authority！"
        redirect_to post_path(@post)
      end
    end

    def check_posts_authority
      @posts.each do |post|
        if !current_user
          @posts = @posts.where(authority: "all")
        elsif current_user.role != "admin"
          if post.authority == 'friend'
            if current_user == post.user
            elsif !(current_user.friend?(post.user))
              @posts = @posts.includes(:user).where.not(id: post.id)
            end
          elsif post.authority == 'myself'
            if current_user != post.user
              @posts = @posts.includes(:user).where.not(id: post.id)
            end
          end
        elsif current_user.role == "admin"
          if post.authority == 'myself'
            if current_user != post.user
              @posts = @posts.includes(:user).where.not(id: post.id)
            end
          end
        end
      end
      @posts = @posts.page(params[:page]).per(20)
    end

end
