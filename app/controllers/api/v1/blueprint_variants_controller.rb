module Api
  class V1::BlueprintVariantsController < ApiController
    def create
      description = params[:description]
      blueprint = Blueprint.similarity_search(description).first

      code = Sublayer::Agents::GenerateCodeFromBlueprintAgent.new(
        blueprint_description: blueprint.description,
        blueprint_code: blueprint.code,
        description: description
      ).execute

      render json: { result: code, buffer_id: params[:buffer_id], start_line: params[:start_line], end_line: params[:end_line] }
    end
  end
end
