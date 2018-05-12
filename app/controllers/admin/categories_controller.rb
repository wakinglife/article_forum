class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:update, :destroy]

  def index
    @categories = Category.page(params[:page]).per(15)
    if params[:id]
      set_category
    else
      @category = Category.new
    end

  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "category was successfully created"
      redirect_to admin_categories_path
    else
      flash[:alert] = "Category was fail to creat. #{@category.errors.full_messages.to_sentence}"
      @categories = Category.page(params[:page]).per(15)
      render :index
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
      flash[:notice] = "category was successfully updated"
    else
      flash[:alert] = "Category was fail to creat. #{@category.errors.full_messages.to_sentence}"
      @categories = Category.page(params[:page]).per(15)
      render :index
    end
  end

  def destroy
      if @category.posts.present?
        flash[:alert] = "Category was associated with posts and can't be deleted"
        redirect_to admin_categories_path
        return
      end
      @category.destroy

      if @category.present?
        flash[:notice] = "Category was successfully deleted."
      else
        flash[:alert] = "Category does not exist."
      end
      redirect_to admin_categories_path
  end

private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end

end
