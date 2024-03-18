describe Api::V1::BlueprintsController, type: :controller do
  describe "POST #create" do
    let(:code) { "code" }
    let(:description) { "description" }
    let(:cat_1) { "cat_1" }
    let(:cat_2) { "cat_2" }
    let(:categories_text) { "#{cat_1}, #{cat_2}" }
    let(:technologies) { [cat_1, cat_2] }
    let(:name) { "name" }
    let(:blueprint) { create(:blueprint) }

    before do
      allow(Sublayer::Generators::CategoriesFromCodeGenerator).to receive(:new).with(code: code).and_return(double(generate: categories_text))
      allow(Sublayer::Generators::CodeDescriptionGenerator).to receive(:new).with(code: code, technologies: technologies).and_return(double(generate: description))
      allow(Sublayer::Generators::NameFromCodeAndDescriptionGenerator).to receive(:new).with(code: code, description: description).and_return(double(generate: name))
      allow(Blueprint).to receive(:new).with(code: code, description: description, name: name).and_return(blueprint)
      allow(blueprint).to receive(:build_categories_from_text).with(categories_text)
    end

    it "returns http success" do
      post :create, params: { code: code }

      expect(response).to have_http_status(:created)
      expect(response.body).to eq({ description: description }.to_json)
    end
  end
end