class BlueprintView < Phlex::HTML
  def initialize(blueprint:)
    @blueprint = blueprint
  end

  def template
    return unless @blueprint
    ul(role: "list", class: "space-y-2 py-4 sm:space-y-4 sm:px-6 lg:px-8 overflow-scroll") do
      li(class: "bg-white px-4 py-6 shadow sm:rounded-lg sm:px-6") do
        div(class: "sm:flex sm:items-baseline sm:justify-between") do
          h3(class: "text-base font-medium") do
            span(class: "text-gray-900") { "Blueprint Name" }
          end
        end

        div(class: "mt-4 space-y-6 text-sm text-gray-800") do
          p { @blueprint.name }
        end
      end
      li(class: "bg-white px-4 py-6 shadow sm:rounded-lg sm:px-6") do
        div(class: "sm:flex sm:items-baseline sm:justify-between") do
          h3(class: "text-base font-medium") do
            span(class: "text-gray-900") { "Blueprint Description" }
          end
        end

        div(class: "mt-4 space-y-6 text-sm text-gray-800") do
          p { @blueprint.description }
        end
      end
      li(class: "bg-white px-4 py-6 shadow sm:rounded-lg sm:px-6") do
        div(class: "sm:flex sm:items-baseline sm:justify-between") do
          h3(class: "text-base font-medium") do
            span(class: "text-gray-900") { "Blueprint Code" }
          end
        end

        div(class: "mt-4 space-y-6 text-sm text-gray-800") do
          p(class: "whitespace-pre-wrap") { @blueprint.code }
        end
      end
    end
  end
end
