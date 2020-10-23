require 'rails_helper'

RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  before do
    @user = User.create(
      name:    "テスト",
      email:   "test@example.com",
      password:"password",
    )
    @post = Post.create(
      name:"テスト", 
      content: "テスト", 
      user: @user,
    )
    @post.image = fixture_file_upload("/files/test.jpg")
    @comment = Comment.create(
      text: "テスト",
    )


  end
  # テキスト、ポスト、ユーザーがあれば有効な状態であること
  it "is valid with a post and user and text" do
    comment = Comment.new(
      text: "テスト",
      post: @post,
      user: @user,
    )
    expect(comment).to be_valid
  end
  # テキストがなければ無効な状態であること
  it "is valid without a text" do
    comment = Comment.new(text: nil)
    comment.valid?
    expect(comment.errors[:text]).to include("を入力してください")
  end
  #テキストが71文字以上であれば無効な状態であること
  it "is valid a 16 characters or more text" do
    comment = Comment.new(text: "a"*71)
    comment.valid?
    expect(comment.errors[:text]).to include("は70文字以内で入力してください")
  end
end
