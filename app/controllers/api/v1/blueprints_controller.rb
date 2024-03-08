module Api
  class V1::BlueprintsController < ApiController
    def create
      code = params[:code]
      description = Sublayer::Agents::GenerateDescriptionFromCodeAgent.new(code: code).execute
      categories_text = Sublayer::Agents::GenerateCategoriesFromCodeAgent.new(code: code).execute
      name = Sublayer::Agents::GenerateNameFromCodeAndDescriptionAgent.new(code: code, description: description).execute

      blueprint = Blueprint.new(code: code, description: description, name: name)
      blueprint.build_categories_from_text(categories_text)

      if blueprint.save
        render json: { description: description }, status: :created
      end
    end
  end
end
