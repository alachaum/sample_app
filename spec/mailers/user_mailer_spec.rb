require "spec_helper"

describe UserMailer do
  
  before(:each) do
    default_url_options[:host] = "localhost:3000"
    @user = Factory(:user)
  end

  describe "class" do
    it "should have a follower_notification class method" do
      UserMailer.should respond_to(:follower_notification)
    end

    it "should have a password_reset_confirmation class method" do
      UserMailer.should respond_to(:password_reset_confirmation)
    end
  end

  describe "New follower notification" do

    before(:each) do
      @follower = Factory(:user, :email => Factory.next(:email))
      @follower.follow!(@user)
      @email = UserMailer.follower_notification(@user, @follower)
    end

    it "should be delivered to the right followed user" do
      @email.should deliver_to(@user.email)
    end

    it "should have the correct subject" do
      @email.should have_subject(/New follower/)
    end

    it "should contain the profile link of the follower" do
      @email.should have_body_text("#{user_url(@follower)}")
    end
  end
  
  describe "Password reset confirmation" do
    
    before(:each) do
      @password_reset = PasswordReset.create({:email => @user.email})
      @email = UserMailer.password_reset_confirmation(@password_reset)
    end
    
    it "should be delivered to the right user" do
      @email.should deliver_to(@user.email)
    end
    
    it "should have the correct subject" do
      @email.should have_subject(/Password reset/)
    end
    
    it "should contain the name of the user" do
      @email.should have_body_text("#{@user.name}")
    end
    
    it "should contain the request edit link with the token" do
      url = "#{edit_password_reset_url(@password_reset)}?token=#{@password_reset.token}"
      @email.should have_body_text("#{url}")
    end
  end
end
