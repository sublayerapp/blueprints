describe Blueprint do
  it { is_expected.to have_and_belong_to_many(:categories) }
  it { is_expected.to callback(:upsert_to_vectorsearch).after(:save).if(:saved_changes?) }
  it { is_expected.to respond_to(:as_vector) }
  it { is_expected.to respond_to(:build_categories_from_text) }
  it { is_expected.to respond_to(:categories_text) }

  describe "#as_vector" do
    it "returns a JSON representation of the blueprint" do
      blueprint = build(:blueprint, name: "My Blueprint", description: "A description")
      expect(blueprint.as_vector).to eq({ description: "A description", name: "My Blueprint" }.to_json)
    end
  end

  describe "#build_categories_from_text" do
    it "creates but does not create duplicate categories" do
      blueprint = create(:blueprint)
      blueprint.build_categories_from_text("Category 1, Category 1")
      expect(blueprint.categories.count).to eq(1)
    end

    it "strips whitespace and downcases category titles" do
      blueprint = build(:blueprint)
      blueprint.build_categories_from_text(" Category 1 , Category 2 ")
      expect(blueprint.categories.first.title).to eq("category 1")
      expect(blueprint.categories.second.title).to eq("category 2")
    end
  end

  describe "#categories_text" do
    it "returns a comma separated list of categories" do
      blueprint = create(:blueprint)
      blueprint.categories << Category.new(title: "Category 1")
      blueprint.categories << Category.new(title: "Category 2")
      expect(blueprint.categories_text).to eq("category 1, category 2")
    end
  end
end