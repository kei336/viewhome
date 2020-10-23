require 'rails_helper'

RSpec.describe "Edit", type: :system do
  let(:user) { FactoryBot.create(:user) }

  # 編集に成功する
  it "successful edit" do
    valid_login(user)
    visit user_path(user)
    click_link "ユーザー編集"

    fill_in "名前", with: "edit"
    fill_in "メールアドレス", with: "edit_test@example.com"
    find('input[type="file"]').click
    attach_file "user[icon]", "app/assets/images/i.jpg"
    fill_in "パスワード(6文字以上)", with: "editpass"
    fill_in "パスワード(確認)", with: "editpass"

    click_button "更新"

    expect(current_path).to eq user_path(user)
    expect(user.reload.name).to eq "edit"
    expect(user.reload.email).to eq "edit_test@example.com"
    expect(page).to have_selector("img[src$='i.jpg']")
    #expect(user.reload.password).to_not eq "editpass"
  end

  # 編集に失敗する
  it "unsuccessful edit" do
    valid_login(user)
    visit user_path(user)
    click_link "ユーザー編集"

    fill_in "名前", with: "edit"
    fill_in "メールアドレス", with: "edit_test@example.com"
    fill_in "パスワード(6文字以上)", with: "editpass"
    fill_in "パスワード(確認)", with: "newpass"
    click_button "更新"

    expect(page).to have_content "パスワード(確認用)とパスワードの入力が一致しません"
    expect(user.reload.email).to_not eq "edit_test@example.com"
  end

  it "successful edit with friendly forwarding" do
    visit user_path(user)
    valid_login(user)
    click_link "ユーザー編集"

    fill_in "名前", with: "edit"
    fill_in "メールアドレス", with: "edit_test@example.com"
    find('input[type="file"]').click
    attach_file "user[icon]", "app/assets/images/i.jpg"
    fill_in "パスワード(6文字以上)", with: "editpass"
    fill_in "パスワード(確認)", with: "editpass"

    click_button "更新"

    expect(current_path).to eq user_path(user)
    expect(user.reload.name).to eq "edit"
    expect(user.reload.email).to eq "edit_test@example.com"
    expect(page).to have_selector("img[src$='i.jpg']")
    #expect(user.reload.password).to_not eq "editpass"
  end

end