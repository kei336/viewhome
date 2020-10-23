require 'rails_helper'


RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: "other_user@example.com") }

  describe User do
    # 有効なファクトリを持つこと
    it "has a valid factory" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end


  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a name, email, and password" do
    user = User.new(
      name:      "テスト",
      email:     "test@example.com",
      password: "password",
    )
    expect(user).to be_valid
  end
 
  # 名がなければ無効な状態であること
  it "is invalid  a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end

  # 名が16文字以上であれば無効であること
  it "is invalid  a 16 characters or more name" do
    user = FactoryBot.build(:user, name: "testtesttesttest")
    user.valid?
    expect(user.errors[:name]).to include("は15文字以内で入力してください")
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  # パスワードがなければ無効な状態であること
  it "is invalid without a password" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  # パスワードが6文字未満であれば無効であること
  it "is invalid a less than 6 characters password" do
    user = FactoryBot.build(:user, password: "aaaaa")
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end


  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "test1@example.com")
    user = FactoryBot.build(:user, email: "test1@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  # ダイジェストが存在しない場合のautheticated?のテスト
  it "is invalid without remember_digest" do
    expect(user.authenticated?(:remember,'')).to eq false
  end

  # フォローしているユーザーの投稿が表示される
  it "is posts of the users you are following are displayed" do
    FactoryBot.create(:post, :post_image, user: other_user)
    user.follow(other_user)
    other_user.posts.each do |post_following|
      expect(user.feed).to include(post_following)
    end
  end

  # 自分の投稿が表示される
  it "is posts of the users you are following are displayed" do
    FactoryBot.create(:post, :post_image, user: user)
    user.posts.each do |post_self|
      expect(user.feed).to include(post_self)
    end
  end

  # フォローしていないユーザーの投稿は表示されない
  it "is posts from unfollowed users are not displayed" do
    FactoryBot.create(:post, :post_image, user: other_user)
    other_user.posts.each do |unfollowed|
      expect(user.feed).to_not include(unfollowed)
    end
  end
end