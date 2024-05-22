describe Api::V1::BlueprintVariantsController, type: :controller do
  describe 'POST #create' do
    let(:blueprint) do
      VCR.use_cassette("#{Rails.configuration.ai_provider}/generic_blueprint_embedding") do
        create(:blueprint)
      end
    end
    let(:description) { 'some description' }
    let(:code) { 'generated code' }
    let(:buffer_id) { 'buffer_id' }
    let(:start_line) { 'start_line' }
    let(:end_line) { 'end_line' }

    before do
      allow(Blueprint).to receive(:similarity_search).with(description).and_return([blueprint])
      allow(Sublayer::Generators::CodeFromBlueprintGenerator).to receive(:new).with(
        blueprint_description: blueprint.description,
        blueprint_code: blueprint.code,
        description: description
      ).and_return(double(generate: code))
    end

    it 'returns code and buffer_id' do
      VCR.use_cassette("#{Rails.configuration.ai_provider}/api_v1_blueprint_variants_controller_create") do
        post :create, params: { description: description, buffer_id: buffer_id, start_line: start_line, end_line: end_line }

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ result: code, buffer_id: buffer_id, start_line: start_line, end_line: end_line }.to_json)
      end
    end
  end
end
