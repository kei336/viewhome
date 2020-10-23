require 'rails_helper'

RSpec.describe "SignUps", type: :system do
  include ActiveJob::TestHelper

  # ユーザーはサインアップに成功する
  it "user successfully signs up" do
    visit root_path
    click_link "新規登録"


    perform_enqueued_jobs do
      expect {
        fill_in "名前",              with: "Example"
        fill_in "メールアドレス",     with: "test@example.com"
        fill_in "パスワード(6文字以上)",         with: "test123"
        fill_in "パスワード(確認)",  with: "test123"
        click_button "作成"
      }.to change(User, :count).by(1)

      expect(page).to have_content "メールアドレスを確認し、ログインしてください"
      expect(current_path).to eq root_path
    end

    
  end
end
