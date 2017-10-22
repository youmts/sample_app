require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other = users(:archer)
    log_in_as(@user)
  end

  test "following page" do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "通常の方法でユーザーをフォローする" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end

  test "Ajaxでユーザーをフォローする" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end

  test "通常の方法でユーザーをフォロー解除する" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

  test "Ajaxでユーザーをフォロー解除する" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

  test "Homeの統計情報が正しく表示されている" do
    get root_path
    assert_select 'strong#following', @user.following.count.to_s
    assert_select 'strong#followers', @user.followers.count.to_s
    get user_path(@user)
    assert_select 'strong#following', @user.following.count.to_s
    assert_select 'strong#followers', @user.followers.count.to_s
  end

  test "Homeのfeedが正しく表示されている" do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end
