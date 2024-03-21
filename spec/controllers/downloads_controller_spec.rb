describe DownloadsController, type: :controller do
  describe 'GET #export' do
    let(:csv) { "csv content" }
    it 'exports a CSV file' do
      allow(Blueprint).to receive(:all).and_return([build(:blueprint)])
      allow(Time).to receive(:now).and_return(Time.new(2020, 1, 1, 0, 0, 0, "+00:00"))
      allow(CSV).to receive(:generate).and_return(csv)

      get :export, params: { titles: ['asdf'] }

      expect(response.headers['Content-Type']).to eq('text/csv; charset=utf-8')
      expect(response.headers['Content-Disposition'].split("; ")).to include('filename="blueprints-2020-01-01-000000.csv"')
      expect(response.body).to eq(csv)
    end

    context 'when no titles are provided' do
      it 'exports all blueprints' do
        allow(Blueprint).to receive(:all).and_return([build(:blueprint)])
        allow(Time).to receive(:now).and_return(Time.new(2020, 1, 1, 0, 0, 0, "+00:00"))
        allow(CSV).to receive(:generate).and_return(csv)

        get :export

        expect(response.headers['Content-Type']).to eq('text/csv; charset=utf-8')
        expect(response.headers['Content-Disposition'].split("; ")).to include('filename="blueprints-2020-01-01-000000.csv"')
        expect(response.body).to eq(csv)
      end
    end

    context 'when titles are provided' do
      it 'exports blueprints with the provided titles' do
        category = create(:category)
        blueprint = create(:blueprint)
        blueprint.categories << category
        blueprint.save

        allow(Time).to receive(:now).and_return(Time.new(2020, 1, 1, 0, 0, 0, "+00:00"))
        expect(Category).to receive(:includes).and_call_original

        get :export, params: { titles: [category.title] }

        expect(response.headers['Content-Type']).to eq('text/csv; charset=utf-8')
        expect(response.headers['Content-Disposition'].split("; ")).to include('filename="blueprints-2020-01-01-000000.csv"')
      end
    end
  end

  describe 'POST #import' do
    it 'imports a CSV file' do
      file = fixture_file_upload('blueprints.csv', 'text/csv')

      expect(Blueprint.count).to eq(0)
      post :import, params: { file: file }

      expect(Blueprint.count).to eq(1)
    end
  end
end