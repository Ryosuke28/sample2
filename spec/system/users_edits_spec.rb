require 'rails_helper'

RSpec.describe "UsersEdits", type: :system do
  # pending "add some scenarios (or delete) #{__FILE__}"
  describe 'ユーザー編集機能' do
    before do
      @user = FactoryBot.create(:user)
      log_in_as(@user)
      click_link 'Account'
      click_link 'Setting'
    end

    it "ユーザー編集ページを表示" do
      expect(current_path).to eq edit_user_path(@user)
    end

    context 'ふさわしくないデータを送信した場合' do
      it 'エラーを表示する' do
        fill_in "Name", with: ""
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        fill_in "Confirmation", with: ""
        click_button 'Save changes'
        # expect(current_path).to eq edit_user_path(@user)
        expect(page).to have_selector('#error_explanation')
        expect(page).to have_selector('.alert-danger', text: 'The form contains 3 errors.')
        expect(page).to have_content("Name can't be blank")
      end
    end

    context '正しいデータを送信した場合' do
      it '変更に成功する' do
        fill_in "Name", with: "Foo Bar"
        fill_in "Email", with: "foo@bar.com"
        fill_in "Password", with: ""
        fill_in "Confirmation", with: ""
        click_button 'Save changes'
        expect(page).to have_selector('.alert')
        expect(current_path).to eq user_path(@user)
        expect(@user.reload.email).to eq "foo@bar.com"
      end
    end
  end
end
