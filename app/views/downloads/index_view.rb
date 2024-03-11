class Downloads::IndexView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes
  include Phlex::Rails::Helpers::FormWith

  def template
    section(aria_labelledby: "downloads-section", class: "flex overflow-hidden flex-col") do
      form_with(url: export_downloads_path, method: "GET", class: "flex flex-row h-20", data: { turbo: false }) do |form|
        form.select(:titles, Category.pluck(:title), { multiple: true }, { class: "flex rounded-lg no-scrollbar h-14 m-3" })
        form.submit("Export", class: "flex btn btn-blue bg-cyan-500 hover:bg-cyan-600 text-white font-bold py-2 px-4 rounded m-3 h-10")
      end

      form_with(url: import_downloads_path, id: "upload-form", class: "flex flex-row h-20", data: { controller: "imports" }) do |form|
        form.file_field(:file, direct_upload: true, style: "display: none;", data: { action: "change->imports#submit" }, id: "file-input")
        button(type: 'submit', data: { action: "click->imports#upload_file" }, class: "block btn btn-blue bg-cyan-500 hover:bg-cyan-600 text-white font-bold py-2 px-4 rounded m-3 h-10") do
          "Import"
        end
      end
    end
  end
end
