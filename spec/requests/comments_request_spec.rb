require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: "otheruser@example.com") }
  let(:guest_user) { FactoryBot.create(:user, email: "guest@example.com") }
  let(:post_image) { FactoryBot.create(:post, :post_image, user: user) }
  let!(:text) { FactoryBot.create(:comment, post: post_image, user: user) }
  
  describe "#create" do

    # ログインしているユーザー
    context "as an authenticated user" do
      # 正常なレスポンスを返すこと
      it "responds successfully" do
        sign_in_as user
        post post_comments_path(post_image), params: {comment: {text: text}, user_id: user.id, post_id: post_image.id },xhr: true
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーの場合
    context "as an guest user" do
      # 投稿にコメントできないこと
      it "is can't comment on a post" do
        sign_in_as guest_user
        expect {
          post post_comments_path(post_image), params: {comment: {text: text}, user_id: guest_user.id, post_id: post_image.id }
        }.to_not change(Comment, :count)
      end
    end
  end

  describe "#destroy" do

    # 違うユーザーの場合
    context "as other user" do
      # コメントを削除できない
      it "is can't delete comment" do
        sign_in_as other_user
        expect{
          delete post_comment_path(post_image.id,text)
        }.to_not change(Comment, :count)
      end
    end
  end


end

