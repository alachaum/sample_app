require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"

  before(:each) do
    @attr = {
      :name => "Test User", 
      :email => "test.user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  it "should create the user given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    user_no_name = User.new(@attr.merge(:name => ""))
    user_no_name.should_not be_valid
  end

  it "should require an email" do
    user_no_email = User.new(@attr.merge(:email => ""))
    user_no_email.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    user_long_name = User.new(@attr.merge(:name => long_name))
    user_long_name.should_not be_valid
  end

  it "should accept valid user addresses" do
    addresses = %w[foo.bar@example.com foobar@truc.com.org CAPITAL@bla.truc]
    addresses.each do |address|
      user_valid_email = User.new(@attr.merge(:email => address))
      user_valid_email.should be_valid
    end
  end

  it "should reject invalid user addresses" do
    addresses = %w[foobar.org @truc foo footruc@.bar]
    addresses.each do |address|
      user_invalid_email = User.new(@attr.merge(:email => address))
      user_invalid_email.should_not be_valid
    end
  end

  it "should reject users with duplicate email" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject user with duplicate email up to case" do
    email_upcase = @attr[:email].upcase
    User.create!(@attr.merge(:email => email_upcase))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe "Password validations" do
    
    it "should require a password" do
      user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
      user.should_not be_valid
    end

    it "should require a matching password confirmation" do
      user = User.new(@attr.merge(:password_confirmation => "invalid"))
      user.should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      user = User.new(@attr.merge(:paasword => short, :password_confirmation => short))
      user.should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      user = User.new(@attr.merge(:password => long, :password_confirmation => long))
      user.should_not be_valid
    end  
  end

  describe "Password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      
      it "should be true if the password matches" do
        @user.has_password?(@attr[:password]).should be_true
      end  

      it "should be false if the password doesn't match" do
        @user.has_password?("invalid").should be_false
      end

    end
    
    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        user_wrong_password = User.authenticate(@attr[:email], "invalid")
        user_wrong_password.should be_nil
      end

      it "should return nil if the user doesn't exist" do
        user_non_existing = User.authenticate("nonexisting@nul.com", @attr[:password])
        user_non_existing.should be_nil
      end

      it "should return the user object if on email/password match" do
        user_valid = User.authenticate(@attr[:email], @attr[:password])
        user_valid.should == @user
      end
    end
  end

end
