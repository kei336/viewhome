require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }
  let(:guest_user) { FactoryBot.create(:guest_user) }
  


  describe "#create" do
    # ログインしているユーザー
    context "as an authenticated user" do
      # 正常なレスポンスを返すこと
      it "responds successfully" do
        sign_in_as user
        post posts_path, params: {post: { name: "テスト", content: "テスト", user_id: user.id } }
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # ゲストユーザーの場合
    context "as an guest user" do
      # 投稿できないこと
      it "is can't post" do
        sign_in_as guest_user
        expect{
          post posts_path, params: {post: { name: "テスト", content: "テスト", user_id: user.id } }
        }.to_not change(Post, :count)
      end
    end
    
    # ログインしていないユーザー
    context "as a not authenticated user" do
      #ログイン画面にリダイレクトすること
      it "is redirects to the login page" do
        post posts_path, params: {post: { name: "テスト", content: "テスト", user_id: user.id } }
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#destroy" do
    let!(:post_image) { FactoryBot.create(:post, :post_image) }
    # ログインしていないユーザー
    context "as a not authenticated user" do    
      # ログイン画面にリダイレクトすること
      it "is redirects to the login page" do
        expect {
          delete post_path(post_image),params: { id: post_image.id, user_id: user.id}
        }.to_not change(Post, :count)
        expect(response).to redirect_to login_path
      end
    end
    
    # アカウントが違うユーザー
    context "as other user" do      
      # ホーム画面にリダイレクトすること
      it "is redirects to the root page" do  
        sign_in_as other_user
        expect {
          delete post_path(post_image),params: {id: post_image.id, user_id: user.id}
        }.to_not change(Post, :count)
        expect(response).to redirect_to root_path
      end
    end
  end
end
