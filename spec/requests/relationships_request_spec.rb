require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe 'ユーザーフォロー機能' do
    before do
      @user = FactoryBot.create(:user)
      @user_a = FactoryBot.create(:user)
      @user_b = FactoryBot.create(:user)
      @user_c = FactoryBot.create(:user)
      
      FactoryBot.create(:relationship, follower_id: @user.id, followed_id: @user_a.id)
      FactoryBot.create(:relationship, follower_id: @user.id, followed_id: @user_b.id)
      FactoryBot.create(:relationship, follower_id: @user_a.id, followed_id: @user.id)
      FactoryBot.create(:relationship, follower_id: @user_c.id, followed_id: @user.id)
    end
    
    context 'ログインしていないとき' do
      it 'ユーザーをフォローできない' do
        expect {
          post relationships_path
        }.not_to change(Relationship, :count)
        expect(response).to redirect_to login_path
      end

      it 'フォローを解除できない' do
        expect {
          delete relationship_path(Relationship.first)
        }.not_to change(Relationship, :count)
        expect(response).to redirect_to login_path
      end
    end

    context 'ログインしているとき' do
      before do
        log_in(@user)
      end

      context 'Ajaxを使わない方法で' do
        it 'ユーザーをフォローできる' do
          expect {
            post relationships_path, params: { followed_id: @user_c.id }
          }.to change(Relationship, :count).by(1)
        end
  
        it 'ユーザーをフォロー解除できる' do
          @user.follow(@user_c)
          relationship = @user.active_relationships.find_by(followed_id: @user_c.id)
          expect {
            delete relationship_path(relationship)
          }.to change(Relationship, :count).by(-1)
        end
      end

      context 'Ajaxを使用する方法で' do
        it 'ユーザーをフォローできる' do
          expect {
            post relationships_path, xhr: true, params: { followed_id: @user_c.id }
          }.to change(Relationship, :count).by(1)
        end
  
        it 'ユーザーをフォロー解除できる' do
          @user.follow(@user_c)
          relationship = @user.active_relationships.find_by(followed_id: @user_c.id)
          expect {
            delete relationship_path(relationship), xhr: true
          }.to change(Relationship, :count).by(-1)
        end
      end


      # it 'リレーションを削除できない' do
      #   expect {
      #     delete relationship_path(Relationship.first)
      #   }.not_to change(Relationship, :count)
      #   expect(response).to redirect_to login_path
      # end
    end
  end

end
