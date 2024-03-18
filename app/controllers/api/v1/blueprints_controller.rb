module Api
  class V1::BlueprintsController < ApiController
    def create
      code = params[:code]
      categories_text = Sublayer::Generators::CategoriesFromCodeGenerator.new(code: code).generate
      technologies = categories_text.split(",").map(&:strip)
      description = Sublayer::Generators::CodeDescriptionGenerator.new(code: code, technologies: technologies).generate
      name = Sublayer::Generators::NameFromCodeAndDescriptionGenerator.new(code: code, description: description).generate

      blueprint = Blueprint.new(code: code, description: description, name: name)
      blueprint.build_categories_from_text(categories_text)

      if blueprint.save
        render json: { description: description }, status: :created
      end
    end
  end
end
