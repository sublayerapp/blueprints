class BlueprintListItem < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  def initialize(blueprint:)
    @blueprint = blueprint
  end

  def template
    li(class: "group relative bg-white px-6 py-5 focus-within:ring-2 focus-within:ring-inset focus-within:ring-blue-600 hover:bg-gray-50") do
      div(class: "flex justify-between space-x-3") do
        div(class: "min-w-0 flex-1") do
          link_to blueprint_path(@blueprint), class: "block focus:outline-none" do
            span(class: "absolute inset-0", aria_hidden: "true") {}
            p(class: "text-sm font-medium text-gray-900 truncate", data: { controller: "inline-edit", inline_edit_target: "name" }) { @blueprint.name }
            p(class: "text-sm text-gray-500 truncate", data: { controller: "inline-edit", inline_edit_target: "description" }) { "Blueprint Categories Placeholder" }
          end
        end
        span(class: "flex-shrink-0 whitespace-nowrap text-sm text-gray-500") { helpers.time_ago_in_words(@blueprint.updated_at) }
      end
      div(class: "mt-1") do
        p(class: "line-clamp-2 text-sm text-gray-600", data: { controller: "inline-edit", inline_edit_target: "description" }) { @blueprint.description.truncate(100) }
      end

      # Toolbar on hover
      div(class: "absolute top-0 right-0 hidden group-hover:flex items-center space-x-2 p-2 z-50") do
        # Edit icon

        # Delete icon
        a(href: "#", data: { controller: "blueprint-list-item", action: "click->blueprint-list-item#delete", blueprint_list_item_id_value: @blueprint.id }, class: "text-gray-400 hover:text-gray-500") do
          svg(class: "h-5 w-5", viewBox: "0 0 20 20", fill: "currentColor") do |s|
            s.path(fill_rule: "evenodd", d: "M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z", clip_rule: "evenodd")
          end
        end
      end
    end
  end
end
