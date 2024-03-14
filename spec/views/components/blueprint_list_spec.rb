describe BlueprintList, type: :phlex do
  include Phlex::Testing::Rails::ViewHelper

  it 'renders the blueprint list' do
    blueprints = create_list(:blueprint, 3)

    rendered = render(BlueprintList.new(blueprints: blueprints))

    blueprints.each do |blueprint|
      expect(rendered).to include(blueprint_path(blueprint))
      expect(rendered).to include(blueprint.name)
      expect(rendered).to include(blueprint.description.truncate(100))
    end
  end
end