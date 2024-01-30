module Api
  class V1::BlueprintChangesController < ApiController
    def create
      changes = params[:description]
      code = params[:code]

      description = Sublayer::Agents::GenerateDescriptionFromCodeAgent.new(code: code).execute

      new_code = Sublayer::Agents::GenerateCodeFromBlueprintAgent.new(
        blueprint_description: description,
        blueprint_code: code,
        description: changes
      ).execute

      render json: { result: code, buffer_id: params[:buffer_id], start_line: params[:start_line], end_line: params[:end_line] }
    end
  end
end
