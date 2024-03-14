FactoryBot.define do
  factory :blueprint do
    sequence(:name) { |i| "blueprint_name_#{i}" }
    sequence(:description) { |i| "blueprint_description #{i}" }
    sequence(:code) { |i| "code #{i}" }
  end
end