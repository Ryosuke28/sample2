require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do

  describe "パスワードリセット機能" do
    before do
      @user = FactoryBot.create(:user)
    end
    it "パスワードが変更できる" do
      # 無効なメールアドレスを送信
      post password_resets_path, params: { password_reset: {
        email: "no@email.com"
      }}
      expect(flash[:danger]).to be_truthy
      expect(response).to render_template(:new)
      # 有効なメールアドレスを送信
      post password_resets_path, params: { password_reset: {
        email: @user.email
      }}
      expect(flash[:info]).to be_truthy
      expect(response).to redirect_to root_path

      # パスワード再設定メールのリンクのテスト
      user = assigns(:user)
      # メールアドレスが無効
      get edit_password_reset_url(user.reset_token, email: "wrong@email.com")
      expect(response).to redirect_to root_path
      # トークンが無効
      get edit_password_reset_url("wrongToken", email: user.email)
      expect(response).to redirect_to root_path
      # どちらも有効
      get edit_password_reset_url(user.reset_token, email: user.email)
      expect(response).to render_template(:edit)

      # updateアクションのテスト
      # 無効なパスワードの送信
      patch password_reset_path(user.reset_token), params: { 
        email: user.email,
        user: {
        password: "foo",
        password_confirmation: "bar"
      }}
      expect(response).to render_template(:edit)
      # パスワードを空で送信
      patch password_reset_path(user.reset_token), params: { 
        email: user.email,
        user: {
        password: "",
        password_confirmation: ""
      }}
      expect(response).to render_template(:edit)
      # 正しい組み合わせで送信
      patch password_reset_path(user.reset_token), params: { 
        email: user.email,
        user: {
        password: "newpassword",
        password_confirmation: "newpassword"
      }}
      expect(flash[:success]).to be_truthy
      expect(session[:user_id]).to eq user.id # ログイン出来たことを確認
      expect(response).to redirect_to user_path(user)


    end
  end

end
