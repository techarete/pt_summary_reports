# == Schema Information
#
# Table name: pt_accounts
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  api_token       :string(255)
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe PtAccount do

  before :each do
    @pt_account = FactoryGirl.build(:pt_account)
    @pt_account.check_pt_connectivity = false
  end

  subject { @pt_account }
  
  it { should respond_to(:email) }
  it { should respond_to(:password) }

  it { should be_valid }

  describe "when email and api_token is not present" do    
    before { @pt_account.email = nil; @pt_account.api_token = nil}
    it {should_not be_valid }
  end

  describe "when email format is invalid and api_token is not present" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      @pt_account.api_token = ''
      addresses.each do |invalid_address|
        @pt_account.email = invalid_address        
        @pt_account.should_not be_valid
      end
    end
  end

  describe "when email format is valid and api_token is not present" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      @pt_account.api_token = ''
      addresses.each do |valid_address|
        @pt_account.email = valid_address
        @pt_account.should be_valid
      end
    end
  end

  describe "when email address is already taken by User and api_token is not present" do
    before do
      @pt_account.api_token = ''
      pt_account_with_same_email = @pt_account.dup
      pt_account_with_same_email.email = @pt_account.email.upcase
      pt_account_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password and api_token is not present" do
    before { @pt_account.password = nil; @pt_account.api_token = nil }
    it { should_not be_valid }
  end

  pending "when email and password is not valid and api_token is not present"

  pending "when api_token is not valid, and email/password is not present"
  
end
