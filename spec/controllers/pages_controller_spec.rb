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
