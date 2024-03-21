require 'csv'

class DownloadsController < ApplicationController
  layout -> { ApplicationLayout }
  def index
    render Downloads::IndexView.new
  end

  def export
    timestamp = Time.now.strftime("%Y-%m-%d-%H%M%S")
    send_data generate_csv, filename: "blueprints-#{timestamp}.csv", type: 'text/csv; charset=utf-8'
  end

  def import
    file = params[:file]
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      params = row.to_h.except(:categories)

      blueprint = Blueprint.find_or_initialize_by(params)
      blueprint.build_categories_from_text(row.to_h[:categories])

      blueprint.save
    end
  end

  private

  def generate_csv
    CSV.generate do |csv|
      csv << ["Name", "Description", "Code", "Categories"]
      blueprints_to_export.each do |blueprint|
        csv << [blueprint.name, blueprint.description, blueprint.code, blueprint.categories_text]
      end
    end
  end

  def blueprints_to_export
    return Blueprint.all unless params[:titles]&.any?(&:present?)

    Category.includes(:blueprints).where(title: [params[:titles]]).map(&:blueprints).flatten
  end
end