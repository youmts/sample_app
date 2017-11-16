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

    it "トークンから作成したダイジェストとトークンを
      BCrypt::Passwordのis_password?で比較するとtrueが返ること" do
      token = User.new_token
      digest = User.digest(token)
      expect(BCrypt::Password.new(digest).is_password?(token)).to be_truthy
    end
  end
end
