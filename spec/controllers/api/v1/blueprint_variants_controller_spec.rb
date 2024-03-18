describe Api::V1::BlueprintVariantsController, type: :controller do
  describe 'POST #create' do
    let(:blueprint) { create(:blueprint) }
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
      post :create, params: { description: description, buffer_id: buffer_id, start_line: start_line, end_line: end_line }

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq({ result: code, buffer_id: buffer_id, start_line: start_line, end_line: end_line }.to_json)
    end
  end
end