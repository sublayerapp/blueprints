describe BlueprintListItem, type: :phlex do
  it 'renders the blueprint list item' do
    blueprint = create(:blueprint)

    rendered = render(BlueprintListItem.new(blueprint: blueprint))

    expect(rendered).to include(blueprint_path(blueprint))
    expect(rendered).to include(blueprint.name)
    expect(rendered).to include(blueprint.description.truncate(100))
  end

  it 'renders the correct blueprint-list-item controller' do
    blueprint = create(:blueprint)

    rendered = render(BlueprintListItem.new(blueprint: blueprint))

    expect(rendered).to include("data-controller=\"blueprint-list-item\"")
    expect(rendered).to include("data-action=\"click-&gt;blueprint-list-item#delete\"")
    expect(rendered).to include("data-blueprint-list-item-id-value=\"#{blueprint.id}\"")
  end
end