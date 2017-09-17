require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "正しくない情報を入力してログインしようとする" do
    get login_path
    assert_template 'sessions/new'
    post login_path,
      params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    assert_select 'div.alert.alert-danger'
    get root_path
    assert flash.empty?
    assert_select 'div.alert.alert-danger', count: 0
  end
  
  test "正しい情報を入力してログインし、ログアウトする" do
    get login_path
    post login_path,
      params: { session: {email: @user.email, password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "a[href=?]", users_path
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path # 2番目のタブにおけるログアウトをシミュレートする
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", users_path, count: 0
  end
  
  test "remember_meした情報でログインする" do
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end
  
  test "remember_meせずにログインする" do
    # クッキーを保存してログイン
    log_in_as(@user, remember_me: '1')
    delete logout_path
    # クッキーを削除してログイン
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
