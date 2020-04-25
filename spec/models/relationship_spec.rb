require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user_a = FactoryBot.create(:user)
    @user_b = FactoryBot.create(:user)

    @relationship = FactoryBot.create(:relationship, follower_id: @user_a.id, followed_id: @user_b.id)
  end

  it 'has a valid factory' do
    expect(@relationship).to be_valid
  end

  context '項目が足りない場合' do
    it 'followerがないときバリデーションを通らない' do
      @relationship.follower_id = nil
      expect(@relationship).to be_invalid
    end

    it 'followedがないときバリデーションを通らない' do
      @relationship.followed_id = nil
      expect(@relationship).to be_invalid
    end
  end
end
