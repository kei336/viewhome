require 'rails_helper'

RSpec.describe Like, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  it "is invalid without a user_id" do
    like = Like.new(user_id: nil)
    like.valid?
    expect(like.errors[:user_id])
  end

  it "is invalid without a post_id" do
    like = Like.new(post_id: nil)
    like.valid?
    expect(like.errors[:post_id])
  end
end
