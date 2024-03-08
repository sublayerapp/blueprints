class Category < ApplicationRecord
  has_and_belongs_to_many :blueprints

  validates :title, presence: true, uniqueness: true

  after_initialize :downcase_title
  before_save :downcase_title

  private

  def downcase_title
    self.title.downcase!
  end
end
