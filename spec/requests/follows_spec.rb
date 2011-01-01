require 'spec_helper'

describe "Follows" do

  before(:each) do
    @user = Factory(:user)
    @followed = Factory(:user, :email => Factory.next(:email))
    integration_sign_in(@user)
  end

  describe "following a user" do
    it "should create the follow relation" do
      lambda do
        visit user_path(@followed)
        click_button 'Follow'
        response.should have_selector("input", :value => "Unfollow")
      end.should change(Relationship, :count).by(1)
    end
  end

  describe "unfollowing a user" do
    it "should destroy the follow relation" do
      @user.follow!(@followed)
      lambda do
        visit user_path(@followed)
        click_button 'Unfollow'
        response.should have_selector("input", :value => "Follow")
      end.should change(Relationship, :count).by(-1)
    end
  end
end
