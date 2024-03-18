module Api
  class V1::BlueprintVariantsController < ApiController
    def create
      description = params[:description]
      blueprint = Blueprint.similarity_search(description).first

      code = Sublayer::Generators::CodeFromBlueprintGenerator.new(
        blueprint_description: blueprint.description,
        blueprint_code: blueprint.code,
        description: description
      ).generate

      render json: { result: code, buffer_id: params[:buffer_id], start_line: params[:start_line], end_line: params[:end_line] }
    end
  end
end
