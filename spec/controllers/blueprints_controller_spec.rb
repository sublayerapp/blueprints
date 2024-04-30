describe BlueprintsController, type: :controller do
  describe 'DELETE #destroy' do
    it 'deletes the blueprint' do
      VCR.use_cassette("generic_blueprint_embedding") do
        blueprint = create(:blueprint)

        expect do
          delete :destroy, params: { id: blueprint.id }
        end.to change(Blueprint, :count).by(-1)
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates the blueprint' do
      blueprint = nil

      VCR.use_cassette("generic_blueprint_embedding") do
        blueprint = create(:blueprint)
      end

      VCR.use_cassette("generic_blueprint_embedding") do
        patch :update, params: { id: blueprint.id, blueprint: { name: 'New name' } }
      end

      blueprint.reload
      expect(blueprint.name).to eq('New name')
    end
  end
end
