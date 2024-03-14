describe BlueprintView, type: :phlex do
  include Phlex::Testing::Rails::ViewHelper
  let (:blueprint) { create(:blueprint) }

  it 'renders the blueprint view' do
    rendered = render(BlueprintView.new(blueprint: blueprint))

    expect(rendered).to include(blueprint.name)
    expect(rendered).to include(blueprint.categories_text)
    expect(rendered).to include(blueprint.description)
    expect(rendered).to include(blueprint.code)
  end

  it 'renders a button to add a new category' do
    rendered = render(BlueprintView.new(blueprint: blueprint))

    expect(rendered).to include("type=\"text\" name=\"category[title]\"")
    expect(rendered).to include("Add")
  end

  it 'renders the correct highlight controller' do
    rendered = render(BlueprintView.new(blueprint: blueprint))

    expect(rendered).to include("data-controller=\"highlight\"")
  end
end