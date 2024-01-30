# frozen_string_literal: true

class Blueprints::ShowView < ApplicationView
  def initialize(blueprints:, blueprint:)
    @blueprints = blueprints
    @blueprint = blueprint
  end

  def template
    section(aria_labelledby: "blueprint-heading", class: "flex h-full min-w-0 flex-1 flex-col overflow-hidden xl:order-last") do
      render BlueprintView.new(blueprint: @blueprint)
    end

    aside(class: "hidden xl:order-first xl:block xl:flex-shrink-0") do
      render BlueprintList.new(blueprints: @blueprints)
    end
  end
end
