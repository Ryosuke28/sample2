require 'rails_helper'

RSpec.describe "UsersProfiles", type: :system do
  # pending "add some scenarios (or delete) #{__FILE__}"
  let(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, content: "first", user: user) }
  let!(:micropost_a) { FactoryBot.create(:micropost, content: "second", user: user) }
  after(:all)  { Micropost.delete_all }

  before do
    30.times do
      FactoryBot.create(:micropost, user: user)
    end 
    log_in_as(user)
  end

  describe 'プロフィール画面' do
    it '画面に必要なものが表示されている' do
      visit user_path(user)
      expect(current_path).to eq user_path(user)
      expect(page).to have_selector 'h1', text: user.name
      expect(page).to have_selector 'div.pagination'
    end
  end



end
