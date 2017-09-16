require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  def setup
    @user = users(:michael)
    remember(@user)
  end
  
  test "session[:userid]がnilの状態でもremember_me機能を使用して
        current_userが正しくユーザを返すこと" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  test "remember_meで保存したダイジェストが間違っている場合に、
        current_userがnilを返すこと" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end