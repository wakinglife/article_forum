class Admin::CategoriesController < Admin::BaseController


  def index
    @categories = Category.page(params[:page]).per(15)
    @category = Category.new

  end
end
