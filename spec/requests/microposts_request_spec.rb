require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe '投稿機能' do
    let(:user) { FactoryBot.create(:user) }
    let(:micropost) { FactoryBot.create(:micropost, user: user) }

    context 'ユーザーがログインしていない場合' do
      it '投稿できない' do
        expect {
          post microposts_path ,params: { micropost: {content: 'sample post'} }
        }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_path
      end

      it '投稿を削除できない' do
        expect {
          delete micropost_path(micropost)
        }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
