describe TopNav, type: :phlex do
  include Phlex::Testing::Rails::ViewHelper

  it 'renders a topnav' do
    rendered = render(TopNav.new)

    expect(rendered).to include("<header")
  end
end