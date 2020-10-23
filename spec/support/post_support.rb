module PostSupport
  def new_post(post)
    visit root_path
    click_link "投稿する"
    fill_in "オススメのアプリ名", with: post.name
    fill_in "アプリのオススメポイント", with: post.content
    attach_file "post[image]", "app/assets/images/IMG_7226.PNG"
    click_button "投稿する"
  end
end

# LoginSupportモジュールをincludeする
RSpec.configure do |config|
  config.include PostSupport
end