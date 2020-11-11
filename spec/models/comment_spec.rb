require 'rails_helper'

RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  let!(:user) { FactoryBot.create(:user) }
  let(:posts) { FactoryBot.create(:post,:post_image)}


  # テキスト、ポスト、ユーザーがあれば有効な状態であること
  it "is valid with a post and user and text" do
    comment = Comment.new(
      text: "test",
      user: user,
      post: posts
    )
    expect(comment).to be_valid
  end
  # テキストがなければ無効な状態であること
  it "is valid without a text" do
    comment = Comment.new(
      text: nil,
      user: user,
      post: posts
    )
    comment.valid?
    expect(comment.errors[:text]).to include("を入力してください")
  end
  #テキストが71文字以上であれば無効な状態であること
  it "is valid a 71 characters or more text" do
    comment = Comment.new(
      text: "a"*71,
      user: user,
      post: posts, 
    )
    comment.valid?
    expect(comment.errors[:text]).to include("は70文字以内で入力してください")
  end
end
