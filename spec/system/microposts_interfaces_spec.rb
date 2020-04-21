require 'rails_helper'

RSpec.describe "MicropostsInterfaces", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, name: "Other User",
      email: "otheruser@example.com" )
    @micropost = FactoryBot.create(:micropost, user: @user)
    @other_micropost = FactoryBot.create(:micropost, user: @other_user)
  end

  # pending "add some scenarios (or delete) #{__FILE__}"
  describe 'メッセージ投稿機能' do
    before do
      log_in_as @user
      visit root_path
    end

    context '新規投稿機能' do
      it '無効な投稿は保存されない' do
        fill_in "micropost[content]", with: ""
        expect {
          click_button "Post"
        }.not_to change(Micropost, :count)
      end

      it '有効な投稿は保存される' do
        fill_in "micropost[content]", with: "Example post"
        expect {
          click_button "Post"
        }.to change(Micropost, :count).by(1)
        expect(current_path).to eq root_path
      end

      context '投稿削除機能' do
        it '自分の投稿を削除できる' do
          expect(page).to have_selector 'a', text: 'delete'
          expect {
            click_link 'delete', match: :first
            page.driver.browser.switch_to.alert.accept
            visit root_path
          }.to change(Micropost, :count).by(-1)
        end

        it '違うユーザーの投稿には削除リンクがない' do
          visit user_path(@other_user)
          expect(page).not_to have_selector 'a', text: 'delete'
        end
      end

    end
    


  end
end
