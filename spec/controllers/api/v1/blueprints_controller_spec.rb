describe Api::V1::BlueprintsController, type: :controller do
  describe "POST #create" do
    let(:code) { "code" }
    let(:description) { "description" }
    let(:categories_text) { "categories_text" }
    let(:name) { "name" }
    let(:blueprint) { create(:blueprint) }

    before do
      allow(Sublayer::Agents::GenerateDescriptionFromCodeAgent).to receive(:new).with(code: code).and_return(double(execute: description))
      allow(Sublayer::Agents::GenerateCategoriesFromCodeAgent).to receive(:new).with(code: code).and_return(double(execute: categories_text))
      allow(Sublayer::Agents::GenerateNameFromCodeAndDescriptionAgent).to receive(:new).with(code: code, description: description).and_return(double(execute: name))
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