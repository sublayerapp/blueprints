require 'csv'

class DownloadsController < ApplicationController
  layout -> { ApplicationLayout }
  def index
    render Downloads::IndexView.new
  end

  def export_all
    timestamp = Time.now.strftime("%Y-%m-%d-%H%M%S")
    send_data generate_csv, filename: "blueprints-all-#{timestamp}.csv", type: 'text/csv; charset=utf-8'
  end

  def import
    file = params[:file]
    CSV.foreach(file, headers: true, header_converters: :symbol) do |row|
      Blueprint.find_or_create_by(row.to_h)
    end
  end

  private

  def generate_csv
    CSV.generate do |csv|
      csv << ["Name", "Description", "Code"]
      Blueprint.all.each do |blueprint|
        csv << [blueprint.name, blueprint.description, blueprint.code]
      end
    end
  end
end