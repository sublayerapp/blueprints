class DownloadsController < ApplicationController
  layout -> { ApplicationLayout }
  def index
    render Downloads::IndexView.new
  end
end