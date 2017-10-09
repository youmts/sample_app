require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = @user.microposts.build(content: 'Lorem ipsum')
  end

  test "有効であること" do
    assert @micropost.valid?
  end

  test "ユーザIDはpresentであること" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "contentはpresentであること" do
    @micropost.content = ' '
    assert_not @micropost.valid?
  end

  test "contentは少なくとも140文字あること" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

  test "最も最近のものが最初に取得できること" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
