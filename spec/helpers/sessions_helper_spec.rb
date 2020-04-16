require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do
  describe 'current_userメソッド' do
    before do
      @user = FactoryBot.create(:user)
      remember(@user)
    end

    context 'session[:user_id]がないとき' do
      it '正しいユーザーを返す' do
        expect(current_user).to eq @user
      end
    end
    
    context 'remember_digestに違う値があるとき' do
      it 'nilを返す' do
        @user.update_attribute(:remember_digest, User.digest(User.new_token))
        expect(current_user).to eq nil
      end
    end


    
  end
end
