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
      @other_user = FactoryBot.create(:user, name: "Other User",
                                             email: "otheruser@example.com" )
    end

    it "returns http success" do
      log_in(@user)
      get edit_user_path(@user)
      expect(response).to have_http_status(:success)
      expect(response.body).to include full_title('Edit user')
    end

    it 'ログインしていない状態ではアクセスできない' do
      get edit_user_path(@user)
      expect(response).to redirect_to login_path
      expect(flash[:danger]).to be_truthy
    end

    it 'ログインしていない状態ではデータを変更できない' do
      patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
      expect(response).to redirect_to login_path
      expect(flash[:danger]).to be_truthy
    end

    context '違うユーザーのデータにアクセスした場合' do
      it 'editアクションはリダイレクトされる' do
        log_in(@other_user)
        get edit_user_path(@user)
        expect(response).to redirect_to root_path
      end

      it 'updateアクションはリダイレクトされる' do
        log_in(@other_user)
        patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
        expect(response).to redirect_to root_path
      end
    end
    
  end

  describe "GET /index" do
    context 'ログインしていない場合' do
      it 'ログインページへリダイレクトされる' do
        get users_path
        expect(response).to redirect_to login_path
      end
    end
  end

end
