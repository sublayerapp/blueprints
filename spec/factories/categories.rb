FactoryBot.define do
  factory :category do
    sequence(:title) { |i| "title #{i}" }
  end
end