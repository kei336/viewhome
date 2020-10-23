require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email:"otheruser@example.com")}
  let(:guest_user) { FactoryBot.create(:user, email: "guest@example.com") }

  describe "#create" do
    # ログインしているユーザー
    context "as an authenticated user" do
      # フォローできること
      it  "is can following user" do
        sign_in_as user
        expect{
          post relationships_path, params: {followed_id: other_user.id}, xhr: true
        }.to change(user.following, :count).by(1)
      end
    end

    # ログインしていないユーザー
    context "as a not authenticated user" do
      # ログインページにリダイレクトすること
      it "is should redirect following" do
        get following_user_path(user)
        expect(response).to redirect_to login_path
      end
    end

    # ゲストユーザーの場合
    context "as an geest user" do
      # フォローできないこと
      it "is can't following user" do
        sign_in_as guest_user
        expect{
          post relationships_path, params: { followed_id: other_user.id }, xhr: true
        }.to_not change(guest_user.following, :count)
      end
    end
  end

  describe "#delete" do
    # ログインしているユーザー
    context "as an authenticated user" do
      # フォロー解除できること
      it  "is can following user" do
        sign_in_as user
        user.follow(other_user)
        expect{
          delete relationship_path(user.id), xhr: true
        }.to change(user.following, :count).by(-1)
      end
    end
    # ログインしていないユーザー
    context "as a not authenticated user" do
      # ログインページにリダイレクトすること
      it "is should redirect followers" do
        get followers_user_path(user)
        expect(response).to redirect_to login_path
      end
    end
  end
end
