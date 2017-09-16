require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  test "root_pathが取得できること" do
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end
  
  test "help_pathが取得できること" do
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "about_pathが取得できること" do
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
  
  test "contact_pathが取得できること" do
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end
  
end
