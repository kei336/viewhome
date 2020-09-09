require 'test_helper'

class HomePagesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get home_pages_top_url
    assert_response :success
  end

  test "should get about" do
    get home_pages_about_url
    assert_response :success
  end

end
