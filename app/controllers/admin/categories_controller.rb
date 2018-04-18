class Admin::CategoriesController < Admin::BaseController


  def index
    @categories = Category.all

    if params[:id]
      set_category
    else
      @category = Category.new
    end
  end
end
