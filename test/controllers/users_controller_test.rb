require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "ログインしていないとき、ログイン画面にリダイレクトする" do
    get users_path
    assert_redirected_to login_url
  end
  
  test "ログインしていないときにeditが呼ばれたら、リダイレクトする" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "ログインしていないときにupdateが呼ばれたら、リダイレクトする" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "webから管理者権限を変更できないこと" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password: "password",
                                            password_confirmation: "password",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  test "別のユーザーによるeditは、リダイレクトする" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "別のユーザーによるupdateは、リダイレクトする" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "ログインしていないとき、destroyしようとするとリダイレクトする" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  test "非管理者でログインしているとき、
        destroyしようとするとリダイレクトする" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end