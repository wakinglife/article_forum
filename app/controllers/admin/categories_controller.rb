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
      @categories = Category.page(params[:page]).per(15)
      render :index
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path
      flash[:notice] = "category was successfully updated"
    else
      @categories = Category.page(params[:page]).per(15)
      render :index
    end
  end

  def destroy
    if @category.classed_posts.count == 0
      @category.destroy
      flash[:alert] = "category was successfully deleted"
    else
      flash[:alert] = "category can't be deleted！！"
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
