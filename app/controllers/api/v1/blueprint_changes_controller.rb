module Api
  class V1::BlueprintChangesController < ApiController
    def create
      changes = params[:description]
      code = params[:code]

      categories_text = Sublayer::Generators::CategoriesFromCodeGenerator.new(code: code).generate
      technologies = categories_text.split(",").map(&:strip)
      description = Sublayer::Generators::CodeDescriptionGenerator.new(code: code, technologies: technologies).generate

      new_code = Sublayer::Generators::CodeFromBlueprintGenerator.new(
        blueprint_description: description,
        blueprint_code: code,
        description: changes
      ).generate

      render json: { result: new_code, buffer_id: params[:buffer_id], start_line: params[:start_line], end_line: params[:end_line] }
    end
  end
end
