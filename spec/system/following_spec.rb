require 'rails_helper'

RSpec.describe "Followings", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user_a = FactoryBot.create(:user)
    @user_b = FactoryBot.create(:user)
    @user_c = FactoryBot.create(:user)
    
    FactoryBot.create(:relationship, follower_id: @user.id, followed_id: @user_a.id)
    FactoryBot.create(:relationship, follower_id: @user.id, followed_id: @user_b.id)
    FactoryBot.create(:relationship, follower_id: @user_a.id, followed_id: @user.id)
    FactoryBot.create(:relationship, follower_id: @user_c.id, followed_id: @user.id)

    log_in_as(@user)
  end

  describe 'followingページ機能' do
    it 'フォローしているユーザーが表示される' do
      visit following_user_path(@user)
      expect(@user.following.empty?).not_to be_truthy
      @user.following.each do |user|
        expect(page).to have_selector 'a', text: user.name
      end
    end
  end

  describe 'followersページ機能' do
    it 'フォローされているユーザーが表示される' do
      visit followers_user_path(@user)
      expect(@user.followers.empty?).not_to be_truthy
      @user.followers.each do |user|
        expect(page).to have_selector 'a', text: user.name
      end
    end
  end

end
