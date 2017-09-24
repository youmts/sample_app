require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @activated = users(:archer)
    @not_activated = users(:not_activated)
  end
  
  test "アクティベートされているユーザのページは表示できる" do
    log_in_as(@user)
    get user_path(@activated)
    assert_template 'users/show'
  end

  test "アクティベートされていないユーザのページは表示できない" do
    log_in_as(@user)
    get user_path(@not_activated)
    assert_redirected_to root_path
  end
end
