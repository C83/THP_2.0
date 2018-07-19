# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  title       :string(50)       not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Lesson, type: :model do
  it "is valid with valid attributes" do
    expect(build(:lesson)).to be_valid
  end

  it "is valid with no description" do
    expect(build(:lesson, description: nil)).to be_valid
  end

  it "is saved with valid attributes" do
    expect { create(:lesson) }.to change { Lesson.count }.by(1)
  end

  it "is invalid with no title" do
    expect(build(:lesson, title: "")).to be_invalid
  end

  it "is invalid with so long title" do
    expect(build(:lesson, title: Faker::Lorem.characters(51))).to be_invalid
  end

  it "is invalid with so long description" do
    expect(build(:lesson, description: Faker::Lorem.characters(301))).to be_invalid
  end

  # With shoulda
  # Same result that "is invalid without title"
  it { should validate_presence_of(:title) }

  # Same result that "is invalid with so long description"
  it { should validate_length_of(:description).is_at_most(300) }
end
