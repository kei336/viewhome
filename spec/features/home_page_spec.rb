require 'rails_helper'

RSpec.feature "HomePages", type: :feature do
  #pending "add some scenarios (or delete) #{__FILE__}"
  describe "Home page" do
    before do
      visit root_path   # 名前付きルートを使用
    end

    # HomeページにStaticPages#homeと表示されていること
    it "should have the content 'viewhome'" do
      expect(page).to have_content "viewhome"
    end

    
  end
end
