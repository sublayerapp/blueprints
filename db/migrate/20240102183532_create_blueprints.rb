class CreateBlueprints < ActiveRecord::Migration[7.1]
  def change
    create_table :blueprints do |t|
      t.text :code
      t.text :description

      t.timestamps
    end
  end
end
