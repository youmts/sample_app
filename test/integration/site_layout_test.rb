require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "layout links while no users are log_in" do
    get root_path
    # header
    assert_select "a[href=?]", root_path,             count: 2
    assert_select "a[href=?]", help_path,             count: 1
    assert_select "a[href=?]", users_path,            count: 0
    assert_select "a[href=?]", user_path(@user),      count: 0
    assert_select "a[href=?]", edit_user_path(@user), count: 0
    assert_select "a[href=?]", logout_path,           count: 0
    assert_select "a[href=?]", login_path,            count: 1
    # body
    assert_select "h1", /Welcome/
    # footer
    assert_select "a[href=?]", about_path,            count: 1
    assert_select "a[href=?]", contact_path,          count: 1
  end

  test "layout links while a user is log_in" do
    get root_path
    log_in_as(@user)
    follow_redirect!
    get root_path
    # header
    assert_select "a[href=?]", root_path,             count: 2
    assert_select "a[href=?]", help_path,             count: 1
    assert_select "a[href=?]", users_path,            count: 1
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", edit_user_path(@user), count: 1
    assert_select "a[href=?]", logout_path,           count: 1
    assert_select "a[href=?]", login_path,            count: 0
    # body
    assert_select "section.user_info"
    # footer
    assert_select "a[href=?]", about_path,            count: 1
    assert_select "a[href=?]", contact_path,          count: 1
  end
end