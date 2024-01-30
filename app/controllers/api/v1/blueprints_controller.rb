module Api
  class V1::BlueprintsController < ApiController
    def create
      code = params[:code]
      description = Sublayer::Agents::GenerateDescriptionFromCodeAgent.new(code: code).execute
      name = Sublayer::Agents::GenerateNameFromCodeAndDescriptionAgent.new(code: code, description: description).execute

      blueprint = Blueprint.new(code: code, description: description, name: name)

      if blueprint.save
        render json: { description: description }, status: :created
      end
    end
  end
end
