require 'rails_helper'

RSpec.describe "UsersLogins", type: :system do
  describe 'ログイン・ログアウト処理' do
    before do
      @user = FactoryBot.create(:user)
      visit login_path
    end
    context '無効なユーザーデータを送信した場合' do
      before do
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        click_button "Log in"
      end
      it 'エラーを1度だけ表示する' do
        expect(page).to have_selector('.alert-danger', text: 'Invalid email/password combination')
        click_link 'Home'
        expect(page).not_to have_selector('.alert')
      end
    end

    context '有効なユーザーデータを送信した場合' do
      before do
        fill_in "Email", with: @user.email
        fill_in "Password", with: @user.password
      end

      it 'ログインし、ヘッダーの内容が変わる' do
        click_button "Log in"
        expect(page).not_to have_link nil, href: login_path
        expect(page).to have_link 'Account'
        click_link "Account"
        expect(page).to have_link 'Profile', href: user_path(@user)
        expect(page).to have_link 'Setting', href: edit_user_path(@user)
        expect(page).to have_link 'Log out', href: logout_path
      end

      it 'ログイン後、ログアウトできる' do
        click_button "Log in"
        click_link "Account"
        click_link "Log out"
        expect(current_path).to eq root_path
        expect(page).to have_link 'Log in', href: login_path
      end
    end

  end
end
