require 'spec_helper'

describe PasswordReset do
  describe "creation" do
    
    before(:each) do
      @user = Factory(:user)
      @nonuser = Factory(:user, :email => Factory.next(:email))
      @nonuser.delete
      @pwreset = PasswordReset.create!({:email => @user.email})
    end
    
    it "should create a password reset entry given valid attributes" do
      PasswordReset.create!({:email => @user.email})
    end
    
    it "should require an email address" do
      invalid_pwreset = PasswordReset.new({:email => ""})
      invalid_pwreset.should_not be_valid
    end
    
    it "should prevent from creating an entry for a non existing user" do
      invalid_pwreset = PasswordReset.new({:email => @nonuser.email})
      invalid_pwreset.should_not be_valid
    end
    
    it "should put the request in an inactive state before save" do
      pwreset = PasswordReset.new({:email => @user.email})
      pwreset.should_not be_active
    end
    
    it "should save the right email address" do
      @pwreset.email.should == @user.email
    end
    
    it "should create a token for the password reset entry" do
      @pwreset.token.should_not be_nil
    end 
      
    it "should put the request in an active state" do
      @pwreset.should be_active
    end

    it "should disable any previous request" do
      pwreset2 = PasswordReset.create!({:email => @user.email})
      @pwreset.reload
      @pwreset.should_not be_active
    end
  end
  
  describe "user association" do
    
    before(:each) do
      @user = Factory(:user)
      @password_reset = PasswordReset.create!({:email => @user.email})
    end

    it "should have a user attribute" do
      @password_reset.should respond_to(:user)
    end
    
    
    it "should relate the request to the right user" do
      @password_reset.user_id.should == @user.id
      @password_reset.user.should == @user
    end
  end  
end
