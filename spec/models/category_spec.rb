describe Category do
  subject { build(:category, title: "UPCASE TITLE") }
  it { is_expected.to have_and_belong_to_many(:blueprints) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title) }
  it { is_expected.to callback(:downcase_title).before(:save) }
end
