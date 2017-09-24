require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end
  
  test "管理者向けのindexページがpaginationとdeleteリンクを含むこと" do
    log_in_as(@admin)
    for i in 1..2 do
      get users_path, params: {page: i}
      assert_template 'users/index'
      assert_select 'div.pagination', count: 2
      first_page_of_users = User.where(activated: true).paginate(page: i)
      first_page_of_users.each do |user|
        assert_select 'a[href=?]', user_path(user), text: user.name
        unless user == @admin
          assert_select 'a[href=?]', user_path(user), text: '削除'
        end
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "非管理者向けのindexページ" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: '削除', count: 0
  end

end
