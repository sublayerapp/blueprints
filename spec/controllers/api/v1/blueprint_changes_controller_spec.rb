describe Api::V1::BlueprintChangesController, type: :controller do
  describe "POST #create" do
    it "returns http success" do
      expect_any_instance_of(Sublayer::Agents::GenerateDescriptionFromCodeAgent).to receive(:execute).and_return("new description")
      expect_any_instance_of(Sublayer::Agents::GenerateCodeFromBlueprintAgent).to receive(:execute).and_return("new code")

      post :create, params: { description: "make these changes", code: "old code" }

      expect(response).to have_http_status(:success)
      expect(response.body).to eq({ result: "new code", buffer_id: nil, start_line: nil, end_line: nil }.to_json)
    end
  end
end