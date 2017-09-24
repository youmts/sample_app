require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end
  
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
  
  test "正しい情報を入力した後、アカウントを有効化してサインアップする" do
    get new_user_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {name: "Example User",
                                        email: "user@example.com",
                                        password: "password",
                                        password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
