require "spec_helper"

describe UserMailer do

  it "should have a follower_notification class method" do
    UserMailer.should respond_to(:follower_notification)
  end

  describe "New follower notification" do

    before(:each) do
      default_url_options[:host] = "localhost:3000"
      @user = Factory(:user)
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
      @email.should have_body_text(/#{user_url(@follower)}/)
    end
  end
end
