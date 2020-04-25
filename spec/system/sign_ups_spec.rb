require 'rails_helper'

RSpec.describe "SignUps", type: :system do
  describe "ユーザー登録" do
    context "パラメータが揃っていない場合" do
      before do
        visit signup_path
        fill_in "Name", with: ""
        fill_in "Email", with: ""
        fill_in "Password", with: ""
        fill_in "Confirmation", with: ""
        click_button "Create my account"
      end
      it "エラーを表示する" do
        expect(page).to have_selector('#error_explanation')
        expect(page).to have_selector('.alert-danger', text: 'The form contains 4 errors.')
        expect(page).to have_content("Name can't be blank")
      end
    end

    context "パラメータが揃っている場合" do
      before do
        visit signup_path
        fill_in "Name", with: "Example User1"
        fill_in "Email", with: "example1@example.com"
        fill_in "Password", with: "password"
        fill_in "Confirmation", with: "password"
        click_button 'Create my account'
      end
      it "ユーザーが登録される" do
        # expect(page).to have_selector('.alert-success', text: 'Welcome to the Sample App!')
      end
    end
  end
end
