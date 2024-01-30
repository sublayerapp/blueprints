class Blueprint < ApplicationRecord
  vectorsearch

  after_save :upsert_to_vectorsearch

  def as_vector
    { description: description, name: name }.to_json
  end
end
