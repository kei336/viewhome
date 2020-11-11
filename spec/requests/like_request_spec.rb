require 'rails_helper'

RSpec.describe "Like", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:guest_user) { FactoryBot.create(:user, email: "guest@example.com") }
  let(:post_image) { FactoryBot.create(:post, :post_image, user_id: user.id) }



  describe "#create" do
    # ログインしているユーザー
    context "as an authenticated user" do
      # 正常なレスポンスを返すこと
      it "responds successfully" do
        sign_in_as user
        post post_likes_path(post_image),params:  { user_id: user.id, post_id: post_image.id },xhr: true
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
      # 投稿にいいねができること
      it "is can like posts" do
        sign_in_as user
        expect{
          post post_likes_path(post_image),params: {post: { user_id: user.id, post_id: post_image.id } },xhr: true
        }.to change(Like, :count).by(1)
      end
    end

    # ログインしていないユーザー
    context "as a not authenticated user" do
      #ログイン画面にリダイレクトすること
      it "is redirects to the login page" do
        expect {
          post post_likes_path(post_image),params: {post: { user_id: user.id, post_id: post_image.id } },xhr: true
        }.to_not change(Like, :count)
        expect(response).to redirect_to login_path
      end
    end

    # ゲストユーザーの場合
    context "as an geest user" do
      # 投稿にいいねできないこと
      it "is can like posts" do
        sign_in_as guest_user
        expect{
          post post_likes_path(post_image),params: {post: { user_id: user.id, post_id: post_image.id } },xhr: true
        }.to_not change(Like, :count)
      end
    end
  end

  describe "#destroy" do
    # ログインしていないユーザー
    context "as a not authenticated user" do
      # ログイン画面にリダイレクトすること
      it "is redirects to the login page" do
        expect {
          delete post_like_path(post_image.id,post_image)
        }.to_not change(Like, :count)
        expect(response).to redirect_to login_path
      end
    end

    # ログインしているユーザー
    context "as an authenticated user" do
      # いいねを取り消せること
      it "is can cancel the likes" do
        sign_in_as user
        post post_likes_path(post_image),xhr: true
        expect {
          delete post_like_path(post_image.id,post_image),xhr: true
        }.to change(Like, :count).by(-1)
      end
    end
  end
end