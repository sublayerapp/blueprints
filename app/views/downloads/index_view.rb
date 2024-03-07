class Downloads::IndexView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  def template
    section(aria_labelledby: "donwloads-section", class: "flex h-full min-w-0 flex-1 flex-col overflow-hidden xl:order-first") do
      link_to(export_all_downloads_path, class: "absolute btn btn-blue bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded m-3") do
        "Export All"
      end
    end
  end
end
