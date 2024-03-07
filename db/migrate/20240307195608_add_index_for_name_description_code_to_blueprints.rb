class AddIndexForNameDescriptionCodeToBlueprints < ActiveRecord::Migration[7.1]
  def change
    add_index :blueprints, [:code, :description, :name], unique: true
  end
end
