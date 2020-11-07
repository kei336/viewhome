require 'rails_helper'

RSpec.describe "Comment", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, email: "otheruser@example.com") }
  let(:post_image) { FactoryBot.create(:post, :post_image, user: user) }


  # 無効な情報では送信できない
  it "doesn't comment with invalid information" do
    valid_login(user)
    expect{
      click_on "home-layout-image"
      find("textarea[placeholder='投稿へのコメントを入力する']").set ""
      click_button "送信する"
    }.to_not change(Comment, :count)
  end

  # コメントに成功する
  it "successful  comment" do
    valid_login(user)
    expect{
      click_on "home-layout-image"
      find("textarea[placeholder='投稿へのコメントを入力する']").set "テスト"
      click_button "送信する"
    }.to change(Comment, :count).by(1)
    expect(page).to have_content "投稿にコメントしました"
    expect(page).to have_content "テスト"
  end

  # 削除に成功する
  it "successful delete" do
    FactoryBot.create(:comment, post: post_image, user: user)
    valid_login(user)
    click_on "home-layout-image"
    expect{
      click_link "削除"
    }.to change(Comment, :count).by(-1)
    expect(page).to have_content "コメントを削除しました"
  end

  # 違うユーザーのコメントは削除できない
  it "different users cannot be delete" do
    FactoryBot.create(:comment, post: post_image, user: other_user)
    valid_login(user)
    click_on "home-layout-image"
    expect(page).to_not have_content "削除"
  end
end