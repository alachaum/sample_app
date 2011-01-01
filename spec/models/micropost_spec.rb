require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "value for content" }
    @recipient = Factory(:user, :email => Factory.next(:email))
    @attr_reply = @attr.merge(:in_reply_to => @recipient.id)
  end

  describe "creation" do

    it "should create a micropost given valid attributes" do
      @user.microposts.create!(@attr)
    end

    it "should create a reply given valid attributes" do
      @user.microposts.create!(@attr_reply)
    end
  end

  describe "user associations" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the right user associated" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end

  describe "replies" do

    before(:each) do
      @micropost = @user.microposts.create(@attr_reply)
    end

    it "should have a in_reply_to attribute" do
      @micropost.should respond_to(:in_reply_to)
    end

    it "should reply to the right user" do
      @micropost.in_reply_to.should == @recipient.id
    end

    it "should have a reply? attribute" do
      @micropost.should respond_to(:reply?)
    end

    it "should be identified as a reply" do
      @micropost.should be_reply
    end
  end

  describe "validations" do

    it "should require a user id" do
      Micropost.new(@attr).should_not be_valid
    end

    it "should require non blank content" do
      @user.microposts.build(:content => "  ").should_not be_valid
    end

    it "should reject long content" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid
    end

    it "should prevent to reply to a non existing user" do
      @attr_reply_invalid = @attr.merge(:in_reply_to => 1000)
      @user.microposts.build(@attr_reply_invalid).should_not be_valid
    end

    it "should prevent to reply to yourself" do
      @attr_reply_invalid = @attr.merge(:in_reply_to => @user.id)
      @user.microposts.build(@attr_reply_invalid).should_not be_valid
    end
  end

  describe "from_users_followed_by" do

    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email => Factory.next(:email))

      @user_post = @user.microposts.create!(:content => "foo")
      @other_post = @other_user.microposts.create!(:content => "bar")
      @third_post = @third_user.microposts.create!(:content => "baz")
      
      @user.follow!(@other_user)
    end

    it "should have a from_user_followed_by class method" do
      Micropost.should respond_to(:from_users_followed_by)
    end

    it "should include the followed user's microposts" do
      Micropost.from_users_followed_by(@user).should include(@other_post)
    end

    it "should include the user's microposts" do
      Micropost.from_users_followed_by(@user).should include(@user_post)
    end

    it "should not include the third user's microposts" do
      Micropost.from_users_followed_by(@user).should_not include(@third_post)
    end
  end

  describe "including_replies" do

    before(:each) do
      @replier = Factory(:user, :email => Factory.next(:email))
      
      @user_post = @user.microposts.create!(:content => "foo")
      @replier_post = @replier.microposts.create!(:content => "REPLY", :in_reply_to => @user.id)
    end

    it "should have a including_replies class method" do
      Micropost.should respond_to(:including_replies)
    end

    it "should include the replier's micropost" do
      Micropost.including_replies(@user).should include(@replier_post)
    end

    it "should include the user's microposts" do
      Micropost.including_replies(@user).should include(@user_post)
    end
  end
end
