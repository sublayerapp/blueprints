class CreateJoinTableBlueprintCategory < ActiveRecord::Migration[7.1]
  def change
    create_join_table :blueprints, :categories do |t|
      t.index [:blueprint_id, :category_id], unique: true
      t.index [:category_id, :blueprint_id]
    end
  end
end
