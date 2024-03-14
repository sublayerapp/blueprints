class CategoriesController < ApplicationController
  def create
    category = Category.find_or_create_by(category_params)

    blueprint.categories << category unless blueprint.categories.include?(category)
    blueprint.save
  end

  private

  def blueprint
    @blueprint ||= Blueprint.find(params[:blueprint_id])
  end

  def category_params
    params[:category][:title].downcase!
    params.require(:category).permit(:title)
  end
end