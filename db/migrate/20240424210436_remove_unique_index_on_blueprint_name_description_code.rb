class RemoveUniqueIndexOnBlueprintNameDescriptionCode < ActiveRecord::Migration[7.1]
  def change
    remove_index :blueprints, name: "index_blueprints_on_code_and_description_and_name"
  end
end
