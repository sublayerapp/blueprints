describe NarrowSidebar, type: :phlex do
  it 'renders a path to root' do
    rendered = render(NarrowSidebar.new)

    expect(rendered).to include(root_path)
  end

  it 'renders a path to downloads' do
    rendered = render(NarrowSidebar.new)

    expect(rendered).to include(downloads_path)
  end
end