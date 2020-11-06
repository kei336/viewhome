require 'rails_helper'

RSpec.describe "Password Reset", type: :request do
  let!(:user) { FactoryBot.create(:user) }

  include ActiveJob::TestHelper


  it "password resets" do
    perform_enqueued_jobs do
      get new_password_reset_path
      expect(response).to render_template(:new)
      assert_select 'input[name=?]', 'password_reset[email]'
      # メールアドレスが無効
      post password_resets_path, params: { password_reset: { email: "" } }
      expect(response).to render_template(:new)
      #メールアドレスが有効
      post password_resets_path, params: { password_reset: { email:user.email } } 
      expect(response).to redirect_to root_path

      # パスワード再設定のフォームテスト
      user = assigns(:user)
      # メールアドレスが無効
      get edit_password_reset_path(user.reset_token, email: "")
      expect(response).to redirect_to root_path
      # 無効なユーザー
      user.toggle!(:activated)
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to redirect_to root_path
      user.toggle!(:activated)
      # メールアドレスが有効で、トークンが無効
      get edit_password_reset_path('wrong token', email: user.email)
      expect(response).to redirect_to root_path
      # メールアドレスもトークンも有効
      get edit_password_reset_path(user.reset_token, email: user.email)
      expect(response).to render_template(:edit)
      # 無効なパスワードとパスワード確認
      patch password_reset_path(user.reset_token), params: { email: user.email,
                                                              user: { password: "password",
                                                                      password_confirmation: "aaaaaa"} }
      expect(response).to render_template(:edit)
      # パスワードが空
      patch password_reset_path(user.reset_token), params: { email: user.email,
                                                              user: { password: "",
                                                                      password_confirmation: ""} }
      expect(response).to render_template(:edit)
      #有効なパスワードとパスワード確認
      patch password_reset_path(user.reset_token), params: { email: user.email,
                                                              user: { password: "password",
                                                              password_confirmation: "password"} }
      expect(response).to redirect_to user_path(user)

      
    end
  end
end

  