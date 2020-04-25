require 'rails_helper'

RSpec.describe "Sessions", type: :request do

  describe "GET /login" do
    it "returns http success" do
      get "/login"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Post /login' do
    context '無効なパラメータを送信した場合' do
      it 'エラーを表示する' do
        post login_path params: { session: {email: '', password: ''} }
        expect(response).to have_http_status(:success)
        expect(flash[:danger]).to be_truthy
      end
    end

    context '有効なパラメータを送信した場合' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'ログインし、ログアウトできる' do
        post login_path params: { session: {email: @user.email, password: @user.password} }
        expect(response).to redirect_to user_path(@user)
        expect(is_logged_in?).to be_truthy
        delete logout_path
        expect(response).to redirect_to root_path
        expect(is_logged_in?).not_to be_truthy
        # タブを2つ開いていてそちらでもログアウトをクリックした場合
        delete logout_path
        expect(response).to redirect_to root_path
        expect(is_logged_in?).not_to be_truthy
      end
    end

    context 'remember_meにチェックを付けた場合' do
      before do
        @user = FactoryBot.create(:user)
      end
      it 'cookieが保存される' do
        post login_path params: { 
          session: {
            email: @user.email,
            password: @user.password,
            remember_me: '1'
            } }
        expect(response).to have_http_status 302
        expect(response.cookies['remember_token']).not_to eq nil
        delete logout_path
        # remember_meのチェックを外した場合
        post login_path params: { 
          session: {
            email: @user.email,
            password: @user.password,
            remember_me: '０'
            } }
        expect(response).to have_http_status 302
        expect(response.cookies['remember_token']).to eq nil
      end

    end
  end

end
