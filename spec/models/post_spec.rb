require 'rails_helper'

RSpec.describe Post, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:user) { FactoryBot.create(:user) }
 
  describe "create" do

    # アプリ名とオススメポイントとホーム画像があれば有効である
    it "is valid with a name, content, and homeimages " do
      post = FactoryBot.build(:post, :post_image, user: user)
      expect(post).to be_valid
    end

    # アプリ名がなければポストは無効である
    it "is invalid without a name" do
      post = FactoryBot.build(:post, :post_image, name: "")
      post.valid?
      expect(post.errors[:name]).to include("を入力してください")
    end

    # オススメポイントがなければポストは無効である
    it "is invalid without a content" do
      post = FactoryBot.build(:post, :post_image, content: "")
      post.valid?
      expect(post.errors[:content]).to include("を入力してください")
    end

    # ホーム画像がなければポストは無効である
    it "is invalid without a image" do
      post = FactoryBot.build(:post)
      post.valid?
      expect(post.errors[:image]).to include("を入力してください")
    end
  end
end
