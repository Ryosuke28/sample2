require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  describe '投稿機能' do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user, name: "Other User",
        email: "otheruser@example.com" )
      @micropost = FactoryBot.create(:micropost, user: @user)
      @other_micropost = FactoryBot.create(:micropost, user: @other_user)
    end
    # let(:user) { FactoryBot.create(:user) }
    # let!(:micropost) { FactoryBot.create(:micropost, user: user) }

    context 'ユーザーがログインしていない場合' do
      it '投稿できない' do
        expect {
          post microposts_path ,params: { micropost: {content: 'sample post'} }
        }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_path
      end

      it '投稿を削除できない' do
        expect {
          delete micropost_path(@micropost)
        }.not_to change(Micropost, :count)
        expect(response).to redirect_to login_path
      end
    end

    context '自分以外の投稿の削除を行った場合' do
      it '削除できない' do
        log_in @user
        expect {
          delete micropost_path(@other_micropost)
        }.not_to change(Micropost, :count)
        expect(response).to redirect_to root_path

      end
    end
  end
end
