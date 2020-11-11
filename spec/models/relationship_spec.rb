require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: "other_user@example.com") }

  # follower_idとfollowed_idがあると有効であること
  it "is valid with a follower_id, followed_id" do
    relationship = Relationship.new(follower_id: user.id,
                                    followed_id: other_user.id,
                                    )
    expect(relationship).to be_valid
  end

  # follower_idがないと無効であること
  it "is invalid without a follower_id" do
    relationship = Relationship.new(follower_id: nil,
                                    followed_id: other_user.id)
    relationship.valid?
    expect(relationship.errors[:follower_id])
  end

  # followed_idがないと無効であること 
  it "is invalid without a followed_id" do
    relationship = Relationship.new(followed_id: nil,
                                    follower_id: user.id)
    relationship.valid?
    expect(relationship.errors[:followed_id])
  end
end
