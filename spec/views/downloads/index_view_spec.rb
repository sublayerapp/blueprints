describe Downloads::IndexView, type: :phlex do
  let!(:categories) { create_list(:category,2) }
  let(:view) { render(described_class.new) }

  it "renders the export button" do
    expect(view).to include("action=\"#{export_downloads_path}\"")
    expect(view).to include("name=\"titles[]\"")
    categories.each do |category|
      expect(view).to include("value=\"#{category.title}\"")
    end
    expect(view).to include("value=\"Export\"")
  end

  it "renders the import button" do
    expect(view).to include("data-controller=\"imports\"")
    expect(view).to include("data-action=\"change-&gt;imports#submit\"")
    expect(view).to include("action=\"#{import_downloads_path}\"")
  end
end