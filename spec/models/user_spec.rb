require 'rails_helper'

describe User do
  describe 'Class Method' do
    it '新たなトークンが取得できること' do
      expect(User.new_token).not_to be_nil
    end

    it 'トークンを2回取得しそれぞれが異なること' do
      expect(User.new_token).not_to eq User.new_token
    end

    it 'ダイジェストを作成できること' do
      expect(User.digest('abs')).not_to be nil
    end

    it '同じトークンから2回ダイジェストを作成しそれぞれが異なること' do
      token = User.new_token
      expect(User.digest(token)).not_to eq User.digest(token)
    end

    it 'トークンから作成したダイジェストとトークンを
      BCrypt::Passwordのis_password?で比較するとtrueが返ること' do
      token = User.new_token
      digest = User.digest(token)
      expect(BCrypt::Password.new(digest).is_password?(token)).to be_truthy
    end
  end

  describe 'Instance Method' do
    let(:user) { build(:user) }

    it '有効なファクトリを持つこと' do
      expect(user).to be_valid
    end

    it '名前がなければ無効であること' do
      user.name = '            '
      expect(user).not_to be_valid
    end

    it 'emailがなければ無効であること' do
      user.email = '           '
      expect(user).not_to be_valid
    end

    it 'nameが長すぎると無効であること' do
      user.name = 'a' * 51
      expect(user).not_to be_valid
    end

    it 'emailは長すぎると無効であること' do
      user.email = 'a' * 244 + '@example.com'
      expect(user).not_to be_valid
    end

    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                        first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      it "email='#{valid_address}' の場合は有効であること" do
        user.email = valid_address
        expect(user).to be_valid
      end
    end

    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                          foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      it "email='#{invalid_address}' の場合は無効であること" do
        user = build(:user, email: invalid_address)
        expect(user).not_to be_valid
      end
    end

    it 'emailがユニークでない場合は無効であること' do
      email = 'test@example.com'
      create(:user, email: email)
      user.email = email.upcase
      expect(user).not_to be_valid
    end

    it 'emailは小文字で保存されていること' do
      email = 'AaXdgA@ASxvgrD.CoM'
      user.email = email
      user.save
      expect(user.reload.email).to eq email.downcase
    end

    describe 'passwordが無効' do
      before do
        user.password = user.password_confirmation = password
      end

      context 'passwordが空の場合' do
        let(:password) { ' ' * 6 }
        it { expect(user).not_to be_valid }
      end

      context 'passwordが短い場合' do
        let(:password) { 'a' * 5 }
        it { expect(user).not_to be_valid }
      end
    end

    it 'remember_tokenで認証できること' do
      user.remember
      expect(user.authenticated?(:remember, user.remember_token)).to be_truthy
    end

    it 'ダイジェストが保存されていないとき、authenticated?はfalseを返すこと' do
      expect(user.authenticated?(:remember, '')).to be_falsey
    end

    it '削除したとき関連付けられたmicropostが削除されること' do
      user.save
      user.microposts.create(content: 'Lorem ipusum')
      expect{ user.destroy }.to change{ Micropost.count }.by(-1)
    end

    it 'フォローしていないユーザーをフォローできること' do
      user.save
      user2 = create(:user)
      expect(user.following?(user2)).to be_falsey
      user.follow(user2)
      expect(user.following?(user2)).to be_truthy
      expect(user2.followers).to include(user)
      user.unfollow(user2)
      expect(user.following?(user2)).to be_falsey
    end

    xit 'feedが正しくpostの結果を返すこと' do
    end
  end
end
