class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index
  before_action :check_author, only: [:edit, :update, :destroy]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  impressionist :actions=>[:show]

  def index
    if current_user
      @posts = Post.readable_posts(current_user).open_public
    else
      @posts = Post.open_public.where(authority: "all")
    end
    render json: {
      data: @posts.map do |post|
        {
          title: post.title,
          content: post.content,
          author: post.user.name,
          image: post.image
         }
      end
    }
  end

  def show
    impressionist(@post)
      if !@post
      render json: {
        message: "Can't find the post!",
        status: 400
      }
      else
        if @post.authority?(current_user)
          @comments = @post.comments
            render json: {
              post:
                {
                  title: @post.title,
                  content: @post.content,
                  author: @post.user.name,
                  authority: @post.authority,
                  status: @post.status,
                  image: @post.image
                },
              comments_data: @comments.map do |comment|
                {
                  content: comment.content
                }
              end
            }
        else
          render json: {
            errors: "Not Allowed!",
            status: 403
          }
        end
      end
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      render json: {
        message: "Post was created successfully!",
        result: @post
      }
    else
      render json: {
        error: @post.errors
      }
    end
  end

  def update
    if @post.update(post_params)
      render json: {
        message: "Post was updated successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def destroy
    @post.destroy
    render json: {
      message: "Post destroy seccessfully!"
    }
  end

private

  def set_post
    @post = Post.find(params[:id])
  end


  def post_params
    params.permit(:title, :date, :content, :image, :public, :authority, category_ids: [])
  end

  def check_author
    unless @post.user == current_user || current_user.admin?
      render json: {
        errors: "You have no authority"
      }
    end
  end

end
