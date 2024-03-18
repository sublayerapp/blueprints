describe Api::V1::BlueprintChangesController, type: :controller do
  describe "POST #create" do
    let (:old_code) { "old code" }
    let (:changes) { "make these changes" }
    let (:description_of_old_code) { "description of old code" }
    let (:new_code) { "new code" }
    let(:cat_1) { "cat_1" }
    let(:cat_2) { "cat_2" }
    let(:categories_text) { "#{cat_1}, #{cat_2}" }
    let(:technologies) { [cat_1, cat_2] }

    it "returns http success" do
      allow(Sublayer::Generators::CategoriesFromCodeGenerator).to receive(:new).with(code: old_code).and_return(double(generate: categories_text))
      allow(Sublayer::Generators::CodeDescriptionGenerator).to receive(:new).with(code: old_code, technologies: technologies).and_return(double(generate: description_of_old_code))
      allow(Sublayer::Generators::CodeFromBlueprintGenerator).to receive(:new).with(
        blueprint_description: description_of_old_code,
        blueprint_code: old_code,
        description: changes
        ).and_return(double(generate: new_code))

      post :create, params: { description: changes, code: old_code }

      expect(response).to have_http_status(:success)
      expect(response.body).to eq({ result: new_code, buffer_id: nil, start_line: nil, end_line: nil }.to_json)
    end
  end
end