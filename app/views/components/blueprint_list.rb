class BlueprintList < Phlex::HTML
  def initialize(blueprints:)
    @blueprints = blueprints
  end

  def template
    div(class: "relative flex h-full w-96 flex-col border-r border-gray-200 bg-gray-100") do
      nav(aria_label: "Blueprint List", class: "min-h-0 flex-1 overflow-y-auto") do
        ul(role: "list", class: "divide-y divide-gray-200 border-b border-gray-200", id: 'blueprint-list') do
          @blueprints.each do |blueprint|
            render BlueprintListItem.new(blueprint: blueprint)
          end
        end
      end
    end
  end
end
