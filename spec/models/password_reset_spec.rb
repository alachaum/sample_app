require 'spec_helper'

describe PasswordReset do
  describe "creation" do
    
    before(:each) do
      @user = Factory(:user)
      @nonuser = Factory(:user, :email => Factory.next(:email))
      @nonuser.delete
    end
    
    it "should create a password reset entry given valid attributes" do
      PasswordReset.create!({:email => @user.email})
    end
    
    it "should prevent from creating an entry for a non existing user" do
      invalid_password = PasswordReset.new(@nonuser.email)
      invalid_password.should_not be_valid
    end
    
    it "should relate the entry to the right user" do
      pwreset = PasswordReset.create!({:email => @user.email})
      pwreset.user_id.should == @user.id
    end
    
    it "should create a token for the password reset entry" do
      pwreset = PasswordReset.create!({:email => @user.email})
      pwreset.token.should_not be_nil
    end
  end  
end
