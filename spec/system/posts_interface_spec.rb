require 'rails_helper'

RSpec.describe "PostInterface", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }
  let(:post) { FactoryBot.create(:post, :post_image, user: user) }
  #let(:post) { FactoryBot.create(:post,:post_image, user: other_user) }

  # 無効な情報では投稿できない
  it "doesn't post with invalid information" do
    valid_login(user)
    expect{
      click_link "投稿する"
      fill_in "オススメのアプリ名", with: ""
      fill_in "アプリのオススメポイント", with: ""
      click_button "投稿する"
    }.to_not change(Post, :count)
    expect(current_path).to eq posts_path
    expect(page).to have_content "アプリ名を入力してください"
    expect(page).to have_content "オススメポイントを入力してください"
    expect(page).to have_content "ホーム画面の画像を入力してください"
  end

  # 投稿に成功する
  it "successful post" do
    valid_login(user)
    expect{
      click_link "投稿する"
      fill_in "オススメのアプリ名", with: post.name
      fill_in "アプリのオススメポイント", with: post.content
      find('input[type="file"]').click
      attach_file "post[image]", "app/assets/images/IMG_7226.PNG"
      click_button "投稿する"
    }.to change(Post, :count).by(1)
    expect(current_path).to eq posts_path
    expect(page).to have_content "投稿しました"
  end
  
  # 削除に成功する
  it "succesful delete" do
    valid_login(user)
    new_post(post)
    expect{
      click_link "削除"
    }.to change(Post, :count).by(-1)
    expect(page).to have_content "投稿を削除しました"
  end

  # 違うユーザーの投稿は削除できない
  scenario "different users cannot be delete" do
    valid_login(user)
    visit users_path(other_user)
    expect(page).to_not have_content "削除"
  end
end
