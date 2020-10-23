require 'rails_helper'

RSpec.describe "Remember me", type: :request do
  let(:user) { FactoryBot.create(:user) }

  context "with valid information" do
    # ログイン中のみログアウトすること
    it "logs in with valid information followed by logout" do
      sign_in_as(user)
      expect(response).to redirect_to user_path(user)

    delete logout_path
    expect(response).to redirect_to root_path
    expect(session[:user_id]).to eq nil

    delete logout_path
    expect(response).to redirect_to root_path
    expect(session[:user_id]).to eq nil
    end
  end

  # remember_me チッェクボックスのテスト
  context "login with remembering" do
    it "rememners cookies" do
      post login_path, params: { session: { email: user.email,
                                      password: user.password,
                                      remember_me: '1' } }
      expect(response.cookies['remember_token']).to_not eq nil
    end
  end

  context "login without remembering" do
    it "doesn't remember cookies" do
      post login_path, params: { session: { email: user.email,
                                      password: user.password,
                                      remember_me: '0'} }
      expect(response.cookies['remember_token']).to eq nil
    end
  end
end