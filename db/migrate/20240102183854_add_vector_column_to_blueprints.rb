class AddVectorColumnToBlueprints < ActiveRecord::Migration[7.1]
  def change
    add_column :blueprints, :embedding, :vector,
      limit: LangchainrbRails
        .config
        .vectorsearch
        .llm
        .default_dimension
  end
end
