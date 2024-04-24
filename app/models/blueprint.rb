class Blueprint < ApplicationRecord
  vectorsearch
  has_and_belongs_to_many :categories

  after_save :upsert_to_vectorsearch, if: :saved_changes?

  validates :name, uniqueness: { scope: %i[description code] }

  def as_vector
    { description: description, name: name }.to_json
  end

  def build_categories_from_text(text)
    category_texts = text.split(",").map(&:strip)
    category_texts.each do |c|
      category = Category.find_or_create_by(title: c.downcase)

      self.categories << category unless self.categories.include?(category)
    end
  end

  def categories_text
    @categories_text ||= categories.pluck(:title).join(", ")
  end
end
