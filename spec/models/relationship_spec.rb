require 'rails_helper'

describe Relationship do
  it 'validであること' do
    relationship = build(:relationship)
    expect(relationship).to be_valid
  end

  it 'follower_idは必須' do
    relationship = build(:relationship, follower_id: nil)
    expect(relationship).not_to be_valid
  end

  it 'followed_idは必須' do
    relationship = build(:relationship, followed_id: nil)
    expect(relationship).not_to be_valid
  end
end