class AddNameToBlueprint < ActiveRecord::Migration[7.1]
  def change
    add_column :blueprints, :name, :string
  end
end
