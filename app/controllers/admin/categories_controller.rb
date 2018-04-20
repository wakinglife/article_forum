class Admin::CategoriesController < Admin::BaseController


  def index
    @categories = Category.page(params[:page]).per(15)
    @category = Category.new

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
    @category.destroy
    flash[:alert] = "category was successfully deleted"
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
