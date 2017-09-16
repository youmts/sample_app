require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "正しくない情報を入力してサインアップしようとする" do
    get new_user_path
    assert_select 'form[action=?]', "/users"
    assert_select 'form[method=?]', "post"
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                        email: "user@invalid",
                                        password: "foo",
                                        password_confirmation: "bar" } }
    end
    assert_select 'div#error_explanation' do
      assert_select 'div.alert', /4\s*個のエラーがあります/
    end
    assert_template 'users/new'
  end
  
  test "正しい情報を入力してサインアップする" do
    get new_user_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert_select 'div.alert.alert-success'
    assert is_logged_in?
  end
end
