require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { FactoryBot.create(:user, admin: true) }
  let(:other_user) { FactoryBot.create(:user, email:"other@example.com") }
  let(:guest_user) { FactoryBot.create(:user, email: "guest@example.com") }


  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to be_successful
      expect(response).to have_http_status "200"
    end
  end

  describe "#create" do
    include ActiveJob::TestHelper

    # 無効なサインアップ情報では無効になる
    it "is invalid signup information" do
      perform_enqueued_jobs do
        expect {
          post users_path, params: { user: {name: "",
                                            email: "invalid@example.com",
                                            password: "password",
                                            password_confirmation: "passinvaid" } }
        }.to_not change(User, :count)
      end
    end

    it "is valid signup information" do
      perform_enqueued_jobs do
        expect {
          post users_path, params: { user: { name: "test",
                                              email: "signuptest@example.com",
                                              password: "password",
                                              password_confirmation: "password" } }                                      
        }.to change(User, :count).by(1)
        expect(response).to redirect_to root_path
        user = assigns(:user)
        sign_in_as(user)
        expect(session[:user_id]).to be_falsey
        get edit_account_activation_path(user.activation_token, email: 'wrong')
        expect(session[:user_id]).to be_falsey
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(session[:user_id]).to eq user.id
        expect(user.name).to eq "test"
        expect(user.email).to eq "signuptest@example.com"
        expect(user.password).to eq "password"
      end
    end
  end
    

  describe "GET #show" do
    # ログイン済のユーザー
    context "as an authenticated user" do
      # 正常なレスポンスを返すこと
      it "responds successfully" do
        sign_in_as user
        get user_path(user)
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end
    # ログインしていないユーザー
    context "as a not authenticated user" do
      # ログイン画面にリダイレクトすること
      it "redirects to the login page" do
        get user_path(user)
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe "#edit" do
    # 認証されたユーザー
    context "as an authorized user" do
      it "responds successfully" do
        sign_in_as user
        get edit_user_path(user)
        expect(response).to be_successful
        expect(response).to have_http_status "200"
      end
    end

    # 認可されていないユーザーの場合
    context "as a not authorized user" do
      # ログイン画面にリダイレクトすること
      it "is redirects to the login page" do
        get edit_user_path(user)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end

    # ゲストユーザーの場合
    context "as an guest user" do
      # 編集できないこと
      it "is cannot be edit" do
        sign_in_as guest_user
        get edit_user_path(guest_user)
        expect(response).to redirect_to root_path
      end
    end

    # アカウントが違うユーザーの場合
    context "as other user" do
      # ホーム画面にリダイレクトすること
      it "is redirects to the root page" do
        sign_in_as other_user
        get edit_user_path(user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    # 認可されたユーザー
    context "as an authorized user" do
      # ユーザーを更新できること
      it "updates a user" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq "NewName"
      end
    end


    # 認可されていないユーザー
    context "as an not authorized user" do
      # ログイン画面にリダイレクトすること
      it "is redirects to the login page" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end

    # ゲストユーザーの場合
    context "as an guest user" do
      # 編集できないこと
      it "is cannot be edit" do
        user_params = FactoryBot.attributes_for(:user, name: "guestName")
        sign_in_as guest_user
        patch user_path(guest_user), params: { id: guest_user.id, user: user_params}
        expect(response).to redirect_to root_path
      end
    end

    # アカウントが違うユーザーの場合
    context "as other user" do
      it "does not update the user" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(user.reload.name).to eq other_user.name
      end

      # ホーム画面にリダイレクトすること
      it "is redirects to the root page" do
        user_params = FactoryBot.attributes_for(:user, name: "NewName")
        sign_in_as other_user
        patch user_path(user), params: { id: user.id, user: user_params }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#destroy" do
    # 認可されたユーザー
    context "as an authotized user" do
      # ユーザーを削除できること
      it "deletes a user" do
        sign_in_as user
        expect {
          delete user_path(other_user), params: { id: user.id }
        }.to change(User, :count).by(-1)
      end
    end
    
    # 認可されていないユーザー
    context "as a not authotized user" do
      # 削除できないこと
      it "not delete a user" do
        sign_in_as other_user
        expect {
          delete user_path(user), params: { id: user.id }
        }.to_not change(User, :count)
      end
    end

    context "if the user is deleted" do
      # ユーザーが削除されると関連するポストが削除されること
      it "associated posts should be destroyed" do
        post = FactoryBot.create(:post,:post_image,user: other_user)
        sign_in_as user
        expect {
          delete user_path(other_user), params: { id: other_user.id }
        }.to change(Post, :count).by(-1)
      end
    end
  end
end
