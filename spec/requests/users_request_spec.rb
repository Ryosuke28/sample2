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
        expect {
          post signup_path, params: { user: user_params }
        }.to change(User, :count).by(1)
        expect(response).to redirect_to root_path
        user = assigns(:user) # controllerの@userインスタンスを取得してuserに代入
        # 有効化していない状態でログインを試す
        log_in(user)
        expect(session[:user_id]).not_to be_truthy # ログイン出来ないことを確認
        # 正しくない有効化トークンでアクセス
        get edit_account_activation_path("invalid token", email: user.email)
        expect(session[:user_id]).not_to be_truthy # ログイン出来ないことを確認
        # 正しくないメールアドレスでアクセス
        get edit_account_activation_path(user.activation_token, email: "worng@email.address")
        expect(session[:user_id]).not_to be_truthy # ログイン出来ないことを確認
        # 正しい組み合わせでアクセス
        get edit_account_activation_path(user.activation_token, email: user.email)
        expect(session[:user_id]).to eq user.id # ログイン出来たことを確認
        expect(user.reload.activated?).to be_truthy
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
        expect {
          post signup_path, params: { user: user_params }
        }.not_to change(User, :count)
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

    context 'ユーザーのadmin属性にアクセスした場合' do
      it '管理者でなければ拒否される' do
        log_in(@other_user)
        expect(@other_user.admin?).not_to be_truthy
        patch user_path(@other_user), params: {
          user: {
            password: @other_user.password,
            password_confirmation: @other_user.password,
            admin: true
          }
        }
        expect(@other_user.reload.admin?).not_to be_truthy
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

    context 'ログインしている場合' do
      before do
        @user = FactoryBot.create(:user)
        log_in(@user)
      end
      
      it 'ユーザーリストを表示する' do
        get users_path
        expect(response.body).to include full_title('All users')
      end
    end
  end

  describe 'ユーザー削除機能' do
    before do
      @user = FactoryBot.create(:user, admin: true)
      @other_user = FactoryBot.create(:user, name: "Other User",
                                             email: "otheruser@example.com" )
    end

    context 'ログインしていない場合' do
      it 'ユーザーは削除されない' do
        expect {
          delete user_path(@other_user)
        }.not_to change(User, :count)
      end
    end

    context '管理者でないユーザーの場合' do
      it 'ユーザーは削除されない' do
        log_in(@other_user)
        expect {
          delete user_path(@other_user)
        }.not_to change(User, :count)
      end
    end

    context '管理者権限を持つユーザーの場合' do
      it 'ユーザーを削除できる' do
        log_in(@user)
        expect {
          delete user_path(@other_user)
        }.to change(User, :count).by(-1)
      end
    end
  end

  describe 'ユーザーフォロー機能' do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end
    context 'ログインしていない場合' do
      it 'ログインページへリダイレクトされる' do
        get following_user_path(@user)
        expect(response).to redirect_to login_path
        get followers_user_path(@user)
        expect(response).to redirect_to login_path
      end
    end
  end

end
