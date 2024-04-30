describe Blueprints::ShowView, type: :phlex do
  let(:blueprint) do
    VCR.use_cassette("generic_blueprint_embedding") do
      create(:blueprint)
    end
  end

  let(:blueprint2) do
    VCR.use_cassette("generic_blueprint_embedding") do
      create(:blueprint)
    end
  end

  let(:blueprints) { [blueprint, blueprint2] }
  let(:view) { render(described_class.new(blueprints: blueprints, blueprint: blueprint2)) }

  it "renders the specified blueprint view" do
    expect(view).to include(blueprint2.name)
    expect(view).to include(blueprint2.description)
    expect(view).to include(blueprint2.code)
  end

  it "renders the blueprint list" do
    expect(view).to include("Blueprint List")
    expect(view).to include(blueprint.name)
    expect(view).to include(blueprint2.name)
  end
end
