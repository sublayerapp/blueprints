# frozen_string_literal: true

class ApplicationLayout < ApplicationView
  include Phlex::Rails::Layout

  def template(&block)
    doctype

    html(class: "h-full bg-gray-100") do
      head do
        title { "Blueprints" }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        favicon_link_tag "favicon.png"
        csp_meta_tag
        csrf_meta_tags
        stylesheet_link_tag "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.3.1/styles/default.min.css", media: "all", "data-turbo-track": "reload"
        stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload"
        stylesheet_link_tag "application", data_turbo_track: "reload"

        javascript_importmap_tags
      end

      body(class: "h-full overflow-hidden") do
        div(class: "flex h-full flex-col") do
          render TopNav.new

          div(class: "flex min-h-0 flex-1 overflow-hidden") do
            render NarrowSidebar.new
            main(class: "min-w-0 flex-1 border-1 border-gray-200 xl:flex") do
              yield
            end
          end
        end
      end
    end
  end
end
