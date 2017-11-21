require 'rails_helper'

describe Micropost do
  it '有効であること' do
    micropost = build(:micropost)
    expect(micropost).to be_valid
  end

  it 'ユーザIDはpresentであること' do
    micropost = build(:micropost, user_id: nil)
    expect(micropost).not_to be_valid
  end

  it 'contentはpresentであること' do
    micropost = build(:micropost, content: ' ')
    expect(micropost).not_to be_valid
  end

  it 'contentは多くとも140文字あること' do
    micropost = build(:micropost, content: 'a' * 141)
    expect(micropost).not_to be_valid
  end
end