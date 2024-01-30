class BlueprintListItem < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  def initialize(blueprint:)
    @blueprint = blueprint
  end

  def template
    li(class: "relative bg-white px-6 py-5 focus-within:ring-2 focus-within:ring-inset focus-within:ring-blue-600 hover:bg-gray-50") do
      div(class: "flex justify-between space-x-3") do
        div(class: "min-w-0 flex-1") do
          link_to blueprint_path(@blueprint), class: "block focus:outline-none" do
            span(class: "absolute inset-0", aria_hidden: "true") {}
            p(class: "text-sm font-medium text-gray-900 truncate") { @blueprint.name }
            p(class: "text-sm text-gray-500 truncate") { "Blueprint Categories Placeholder" }
          end
        end
        span(class: "flex-shrink-0 whitespace-nowrap text-sm text-gray-500") { helpers.time_ago_in_words(@blueprint.updated_at) }
      end
      div(class: "mt-1") do
        p(class: "line-clamp-2 text-sm text-gray-600") { @blueprint.description.truncate(100) }
      end
    end
  end
end
