describe TopNav, type: :phlex do
  it 'renders a topnav' do
    rendered = render(TopNav.new)

    expect(rendered).to include("<header")
  end
end