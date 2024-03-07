class Downloads::IndexView < ApplicationView
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::Routes

  def initialize
  end

  def template
    # section(aria_labelledby: "blueprint-heading", class: "flex h-full min-w-0 flex-1 flex-col overflow-hidden xl:order-last") do
    #   render BlueprintView.new(blueprint: @blueprints.first)
    # end

    # aside(class: "hidden xl:order-first xl:block xl:flex-shrink-0") do
    #   render BlueprintList.new(blueprints: @blueprints)
    # end
  end
end
