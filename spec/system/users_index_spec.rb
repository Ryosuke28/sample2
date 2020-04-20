require 'rails_helper'

RSpec.describe "UsersIndex", type: :system do
  before do
    @user = FactoryBot.create(:user, admin: true)
    @other_user = FactoryBot.create(:user, name: "Other User",
                                            email: "otheruser@example.com" )
    log_in_as(@user)
    click_link 'Users'
  end
  
  describe 'ユーザー一覧表示機能' do
    before(:all) { 30.times { FactoryBot.create(:user) } }
    after(:all)  { User.delete_all }

    it "ユーザー一覧ページを表示" do
      expect(current_path).to eq users_path
      expect(page).to have_selector 'div.pagination'
      User.paginate(page: 1).each do |user|
        expect(page).to have_selector 'a', text: user.name
      end
    end
    
    context 'ユーザー削除機能' do
      it '管理者はユーザーを削除できる' do
        User.paginate(page: 1).each do |user|
          unless user == @user
            expect(page).to have_selector 'a', text: 'delete'
          end
        end
        expect {
          click_link 'delete', match: :first
          page.driver.browser.switch_to.alert.accept
          click_link 'Users'
        }.to change(User, :count).by(-1)
      end
    end

  end

end
