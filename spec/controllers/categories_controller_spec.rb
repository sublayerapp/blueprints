describe CategoriesController, type: :controller do
  describe 'POST #create' do
    let(:blueprint) do
      VCR.use_cassette("#{Rails.configuration.ai_provider}/generic_blueprint_embedding") do
        create(:blueprint)
      end
    end
    let(:title) { 'New Category' }
    let(:category_params) { { category: { title: title } } }

    it 'creates a new category' do
      expect do
        post :create, params: { blueprint_id: blueprint.id }.merge(category_params)
      end.to change(Category, :count).by(1)
    end

    it 'adds the category to the blueprint' do
      post :create, params: { blueprint_id: blueprint.id }.merge(category_params)
      category = Category.last
      expect(blueprint.categories).to include(category)
    end

    it 'does not add the category to the blueprint if it already exists' do
      category = create(:category, title: title)
      blueprint.categories << category
      post :create, params: { blueprint_id: blueprint.id }.merge(category_params)
      expect(blueprint.categories.count).to eq(1)
    end
  end
end
