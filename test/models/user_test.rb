require 'test_helper'

class UserClassMethodTest < ActiveSupport::TestCase
  test "新たなトークンが取得できること" do
    assert User.new_token
  end
  
  test "ダイジェストを作成できること" do
    assert User.digest("abc")
  end
  
  test "トークンを二回取得しそれぞれが異なること" do
    assert_not_equal User.new_token, User.new_token
  end
  
  test "同じトークンから二回ダイジェストを作成しそれぞれが異なること" do
    token = User.new_token
    assert_not_equal User.digest(token), User.digest(token)
  end
  
  test "トークンから作成したダイジェストとトークンを
        BCrypt::Passwordのis_password?で比較するとtrueが返ること" do
    token = User.new_token
    digest = User.digest(token)
    assert BCrypt::Password.new(digest).is_password?(token)
  end
end

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: "foobar", password_confirmation: "foobar")
  end
  
  test "validであること" do
    assert @user.valid?
  end
  
  test "nameは空でないこと" do
    @user.name = "         "
    assert_not @user.valid?
  end
  
  test "emailは空でないこと" do
    @user.email = "                 "
    assert_not @user.valid?
  end
  
  test "nameは長すぎてはいけない" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "emailは長すぎてはいけない" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "emailは正しいアドレスを許容すること" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address} should be valid"
    end
  end
  
  test "emailは正しくないアドレスを拒否すること" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address} should be invalid"
    end
  end
  
  test "emailはユニークであること" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "emailは小文字で保存されていること" do
    mixed_case_email = "AaXdgA@ASxvgrD.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "passwordは空でないこと" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "passwordは短すぎないこと" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "remember_tokenで認証できること" do
    @user.remember
    @user.authenticated?(:remember, @user.remember_token)
  end
  
  test "ダイジェストが保存されていないとき、authenticated?はfalseを返すこと" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "関連付けられたmicropostが削除されること" do
    @user.save
    @user.microposts.create(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "フォローしていないユーザーをフォローできること" do
    michael = users(:michael)
    archer = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feedが正しくpostの結果を返すこと" do
    michael = users(:michael)
    archer = users(:archer)
    lana = users(:lana)
    # フォローしているユーザーの投稿を確認
    lana.microposts.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    archer.microposts.each do |post_unfollowing|
      assert_not michael.feed.include?(post_unfollowing)
    end
  end
end
