class BlueprintsController < ApplicationController
  layout -> { ApplicationLayout }

  # GET blueprints
  def index
    @blueprints = Blueprint.all.order(updated_at: :desc)

    render Blueprints::IndexView.new(
      blueprints: @blueprints
    )
  end

  def destroy
    @blueprint = Blueprint.find_by(id: params[:id])
    @blueprint.destroy
    head :no_content
  end

  # GET blueprints/:id
  def show
    @blueprints = Blueprint.all.order(updated_at: :desc)
    @blueprint = Blueprint.find_by(id: params[:id])

    render Blueprints::ShowView.new(
      blueprints: @blueprints,
      blueprint: @blueprint
    )
  end

  # Edit and update actions
  def edit
    @blueprint = Blueprint.find_by(id: params[:id])
  end

  def update
    @blueprint = Blueprint.find_by(id: params[:id])
    @blueprint.update(blueprint_params)
    redirect_to blueprint_path(@blueprint)
  end

  private

  def blueprint_params
    params.require(:blueprint).permit(:name, :description, :code)
  end
end
