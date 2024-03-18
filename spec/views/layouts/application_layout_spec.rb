describe ApplicationLayout, type: :phlex do
  let(:innerview_text) { 'hello world' }
  let(:innerview) { proc { innerview_text } }
  let(:view) { render(described_class.new &innerview) }

  it "renders the correct headers" do
    expect(view).to include('<title>Blueprints</title>')
    expect(view).to include('<link rel="stylesheet" href="/assets/tailwind-')
    expect(view).to include('link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.3.1/styles/default.min.css"')
  end

  it "renders body" do
    sidebar = '<nav aria-label="Sidebar"'
    expect(view).to include(sidebar)
    expect(view).to include(innerview_text)
  end
end