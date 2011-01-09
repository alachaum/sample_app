require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do

    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
                                    :content => "Ruby on Rails Tutorial Sample App | Home")
    end  

    describe "when signed in" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        50.times do |n|
          Factory(:micropost, :user => @user, :content => "Message #{n}")
        end
        @other_user = Factory(:user, :email => Factory.next(:email))
        @other_user.follow!(@user)
      end

      it "should contain the micropost form" do
        get :home
        response.should have_selector("textarea", :id => "micropost_content")
      end

      it "should display the proper number of microposts" do
        get :home
        response.should have_selector("span", :content => "50 microposts")
      end

      it "should paginate the microposts" do
        get :home
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/?page=2",
                                           :content => "Next")
      end

      it "should have the right following/followers count" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                  :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                   :content => "1 follower")
      end 

      describe "the user feed" do

        before(:each) do
          @followed = Factory(:user, :email => Factory.next(:email))
          @replier = Factory(:user, :email => Factory.next(:email))
          @user.follow!(@followed)
        end

        it "should display a followed user's micropost properly"  do
          mp = @followed.microposts.create!(:content => "blabla")
          get :home
          response.should have_selector("span.title a", :href => user_path(@followed),
                                       :content => @followed.name)
          response.should have_selector("span.content", :content => mp.content)
        end

        it "should display a reply made to the user properly" do 
          mp = @replier.microposts.create!(:content => "blabla", :in_reply_to => @user.id)
          get :home
          response.should have_selector("span.title a", :href => user_path(@replier),
                                        :content => @replier.name)
          response.should have_selector("span.title a", :href => user_path(@user),
                                        :content => "You")
          response.should have_selector("span.content", :content => mp.content)
        end

         it "should display a reply made to a followed user properly" do
          mp = @replier.microposts.create!(:content => "blabla", :in_reply_to => @followed.id)
          get :home
          response.should have_selector("span.title a", :href => user_path(@replier),
                                        :content => @replier.name)
          response.should have_selector("span.title a", :href => user_path(@followed),
                                        :content => @followed.name)
          response.should have_selector("span.content", :content => mp.content)
        end

        it "should be present for each post coming from another user" do
          mp = @followed.microposts.create!(:content => "blabla")
          get :home
          response.should have_selector("td a", :href => "#",  
                                        :class => "reply_button",
                                        :content => "reply", 
                                        :user_name => @followed.name,
                                        :user_id => @followed.id.to_s,
                                        :link => user_path(@followed)
                                       )
        end
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
                                    :content => "Ruby on Rails Tutorial Sample App | Contact")
    end  
  end


  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                                    :content => "Ruby on Rails Tutorial Sample App | About")
    end  
  end
  

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
                                    :content => "Ruby on Rails Tutorial Sample App | Help")
    end  
  end
end
