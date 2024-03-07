class Downloads::IndexView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::FormWith

  def template
    section(aria_labelledby: "donwloads-section", class: "flex flex-row h-full min-w-0 flex-1 overflow-hidden xl:order-first") do
      link_to(export_all_downloads_path, class: "block btn btn-blue bg-cyan-500 hover:bg-cyan-600 text-white font-bold py-2 px-4 rounded m-3 h-10 mr-0") do
        "Export All"
      end
      form_with(url: import_downloads_path, id: "upload-form", data: { controller: "imports" }) do |form|
        form.file_field(:file, direct_upload: true, style: "display: none;", data: { action: "change->imports#submit" }, id: "file-input")
        button(type: 'submit', data: { action: "click->imports#upload_file" }, class: "block btn btn-blue bg-cyan-500 hover:bg-cyan-600 text-white font-bold py-2 px-4 rounded m-3 h-10") do
          "Import"
        end
      end
    end
  end
end
