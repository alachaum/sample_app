require 'spec_helper'

describe "Pages" do
  describe "reply button" do
    
    before(:each) do
      @user = Factory(:user)
      @followed = Factory(:user, :email => Factory.next(:email))
      @user.follow!(@followed)
      @mp = @followed.microposts.create!(:content => "blabla")
      integration_sign_in(@user)
    end

#    it "should add a user_id input field when clicking on it" do
#      visit root_path
#      click_link "Reply"
#      response.should have_selector("input#micropost_reply_to",
#                                    :value => @followed.id.to_s)
#    end
  end
end
