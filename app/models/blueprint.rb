class Blueprint < ApplicationRecord
  vectorsearch
  has_and_belongs_to_many :categories

  after_save :upsert_to_vectorsearch

  def as_vector
    { description: description, name: name }.to_json
  end

  def build_categories_from_text(text)
    category_texts = text.split(",").map(&:strip).map(&:downcase)
    categories = category_texts.map do |c|
      Category.find_or_create_by(title: c)
    end
    self.categories << categories
  end
end
