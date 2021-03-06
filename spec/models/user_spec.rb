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

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible into an admin" do
      @user.toggle(:admin)
      @user.should be_admin
    end
  end

  describe "micropost association" do
    
    before(:each) do
      @user = User.create!(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
    end

    it "should have a microposts attribute" do
      @user.should respond_to(:microposts)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [@mp2, @mp1]
    end

    it "should destroy the associated microposts" do
      @user.destroy
      [@mp1, @mp2].each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status feed" do

      before(:each) do
        @followed = Factory(:user, :email => Factory.next(:email))
        @replier = Factory(:user, :email => Factory.next(:email))
        @user.follow!(@followed)
      end

      it "should have a feed" do
        @user.should respond_to(:feed)
      end

      it "should include the user's micropost" do
        @user.feed.include?(@mp1).should be_true
        @user.feed.include?(@mp2).should be_true
      end

      it "should not include a different user's micropost" do
        mp = Factory(:micropost, 
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(mp).should be_false
      end

      it "should include the microposts of followed users" do
        mp = @followed.microposts.create!(:content => "foo")
        @user.feed.should include(mp)
      end

      it "should include the replies made to the user" do
        mp = @replier.microposts.create!(:content => "foo", :in_reply_to => @user.id)
        @user.feed.should include(mp)
      end

      it "should include the replies made to the followed user" do
        mp = @replier.microposts.create!(:content => "foo", :in_reply_to => @followed.id)
        @user.feed.should include(mp)
      end

      it "should not include a replier single post" do
        mp = @replier.microposts.create!(:content => "foo")
        @user.feed.should_not include(mp)
      end
    end
  end

  describe "relationships" do

    before(:each) do
      @user = User.create(@attr)
      @followed = Factory(:user)
    end

    it "should have a relationships method" do
      @user.should respond_to(:relationships)
    end

    it "should have a following method" do
      @user.should respond_to(:following)
    end

    it "should have a following? method" do
      @user.should respond_to(:following?)
    end

    it "should have a follow! method" do
      @user.should respond_to(:follow!)
    end

    it "should follow another user" do
      @user.follow!(@followed)
      @user.should be_following(@followed)
    end

    it "should include the followed user in the following array" do
      @user.follow!(@followed)
      @user.following.should include(@followed)
    end

    it "should have an unfollow! method" do
      @user.should respond_to(:unfollow!)
    end

    it "should unfollow a used" do
      @user.follow!(@followed)
      @user.unfollow!(@followed)
      @user.should_not be_following(@followed)
    end

    it "should have a reverse_relationship method" do
      @user.should respond_to(:reverse_relationship)
    end

    it "should have a followers method" do
      @user.should respond_to(:followers)
    end

    it "should include the follower user in the followers array" do
      @user.follow!(@followed)
      @followed.followers.should include(@user)
    end
  end
  
  describe "password reset association" do
    
    before(:each) do
      @user = User.create!(@attr)
      @password_reset = PasswordReset.create!({:email => @user.email})
    end

    it "should have a password_resets attribute" do
      @user.should respond_to(:password_resets)
    end

    it "should destroy the associated password resets" do
      @user.destroy
      PasswordReset.find_by_id(@password_reset.id).should be_nil
    end
  end
end
