require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  
  test "編集に失敗する" do
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    assert_redirected_to user_path(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                      email: "foo@invalid",
                                      password: "foo",
                                      password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'div.alert', /4\s*個のエラーがあります。/
  end
  
  test "フレンドリーフォワーディングによって編集に成功する" do
    get edit_user_path(@user)
    assert_equal edit_user_url, session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
# MEMO: この場合は右はfalseになる    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
end
