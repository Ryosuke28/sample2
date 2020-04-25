require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let!(:micropost) { FactoryBot.create(:micropost, user: user) }
  let!(:micropost_a) { FactoryBot.create(:micropost, user: user) }


  it 'factoryはバリデーションを通る' do
    expect(micropost).to be_valid
  end

  it 'ユーザーのない投稿はバリデーションを通らない' do
    micropost.user = nil
    expect(micropost).to be_invalid
    expect(micropost.errors).to include(:user)
  end

  describe '投稿機能' do
    context 'contentが空のとき' do
      it 'バリデーションを通らない' do
        micropost.content = ""
        expect(micropost).to be_invalid
        micropost.content = "  "
        expect(micropost).to be_invalid
      end
    end

    context 'contentが1401文字以上のとき' do
      it 'バリデーションを通らない' do
        micropost.content = "a" * 141
        expect(micropost).to be_invalid
      end
    end

    context 'micropostが複数あるとき' do
      it '新しい順に呼び出される' do
        expect(micropost_a).to eq Micropost.first
      end
    end
  end
end
