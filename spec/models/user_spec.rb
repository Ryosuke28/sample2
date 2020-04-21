require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end
  
  it 'has a valid factory' do
    expect(@user).to be_valid
  end

  context 'have blank name' do
    it 'should be invalid' do
      @user.name = "  "
      expect(@user).to be_invalid
    end
  end

  context 'have blank email' do
    it 'should be invalid' do
      @user.email = "  "
      expect(@user).to be_invalid
    end
  end

  context 'have too long name' do
    it 'should be invalid' do
      @user.name = "a" * 51
      expect(@user).to be_invalid
    end
  end

  context 'have too long email' do
    it 'should be invalid' do
      @user.name = "a" * 244 + "@example.com"
      expect(@user).to be_invalid
    end
  end

  describe 'have correct email format' do
    it 'should be valid' do
      valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe 'have incorrect email format' do
    it 'should be invalid' do
      invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to be_invalid
      end
    end
  end

  describe 'have a duplicate email adress' do
    it 'should be invalid' do
      FactoryBot.create(:user, email: "duplicate@example.com")
      dup_user = FactoryBot.build(:user, email: "Duplicate@example.com")
      expect(dup_user).to be_invalid
      expect(dup_user.errors[:email]).to include("has already been taken")
    end
  end

  describe 'before_save work' do
    it 'email should be downcase' do
      @user.email = "DOWNcase@example.COM"
      @user.save
      expect(@user.reload.email).to eq "downcase@example.com"
    end
  end

  describe 'have short password' do
    it 'should be invalid' do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).to be_invalid
    end
  end

  describe 'have blank password' do
    it 'should be invalid' do
      @user.password = @user.password_confirmation = " " * 6
      expect(@user).to be_invalid
    end
  end

  describe 'authenticated?にnilを与えたとき' do
    it 'falseを返す' do
      expect(@user.authenticated?(:remember, '')).not_to be_truthy
    end
  end

  describe 'userを削除したとき' do
    it '投稿も削除される' do
      @user.microposts.create!(content: "test post")
      expect {
        @user.destroy
      }.to change(Micropost, :count).by(-1)
    end
  end
end
