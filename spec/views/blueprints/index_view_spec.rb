describe Blueprints::IndexView, type: :phlex do
  let(:blueprint) { create(:blueprint) }
  let(:blueprint2) { create(:blueprint) }
  let(:blueprints) { [blueprint, blueprint2] }
  let(:view) { render(described_class.new(blueprints: blueprints)) }

  it "renders the first blueprint view" do
    expect(view).to include(blueprint.name)
    expect(view).to include(blueprint.description)
    expect(view).to include(blueprint.code)
  end

  it "renders the blueprint list" do
    expect(view).to include("Blueprint List")
    expect(view).to include(blueprint.name)
    expect(view).to include(blueprint2.name)
  end
end