class Blueprint < ApplicationRecord
  vectorsearch
  has_and_belongs_to_many :categories

  after_save :upsert_to_vectorsearch

  def as_vector
    { description: description, name: name }.to_json
  end
end
