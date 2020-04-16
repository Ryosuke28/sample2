require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /new" do
    it "returns http success" do
      get signup_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include full_title('Sign up')
    end
  end

  describe "POST /create" do
    context 'パラメータが揃っている場合' do
      # 有効なユーザーデータの作成
      let(:user_params) { FactoryBot.attributes_for(:user) }
      it "ユーザーが登録される" do
        expect do
          post signup_path, params: { user: user_params }
        end.to change(User, :count).by(1)
        expect(page).to redirect_to user_path(User.last)
        expect(response).to have_http_status 302
      end
    end

    context 'パラメータが不足している場合' do
      # 無効なユーザーデータの作成
      let(:user_params) do
        FactoryBot.attributes_for(
          :user, name: '',
                 email: 'user@example.com',
                 password: 'password',
                 password_confirmation: 'password')
      end
      it "ユーザーは登録されない" do
        expect do
          post signup_path, params: { user: user_params }
        end.to change(User, :count).by(0)
      end
    end
  end

  describe "GET /edit" do
    before do
      @user = FactoryBot.create(:user)
      post login_path params: { 
        session: {
          email: @user.email,
          password: @user.password,
          remember_me: '1'
          } }
    end

    it "returns http success" do
      get edit_user_path(@user)
      expect(response).to have_http_status(:success)
      expect(response.body).to include full_title('Edit user')
    end
    
  end

end
