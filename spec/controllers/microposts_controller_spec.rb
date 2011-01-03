require 'spec_helper'

describe MicropostsController do
  render_views
  
  describe "access control" do
  
    it "should deny access to 'index'"do
      user = Factory(:user)
      get :index, :user_id => user
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "GET 'user micropost index'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
      @req_user = Factory(:user, :email => Factory.next(:email))
    end

    it "should be successful" do
      get :index, :user_id => @req_user
      response.should be_successful
    end

    it "should have the right title" do
      get :index, :user_id => @req_user
      response.should have_selector("title", :content => @req_user.name)
    end

    it "should display the requested user's microposts" do
      mp = Factory(:micropost, :user => @req_user, :content => "Foooo bar")
      get :index, :user_id => @req_user
      response.should have_selector("span.content", :content => mp.content)
    end

    it "should paginate the microposts" do
      40.times do
        Factory(:micropost, :user => @req_user, :content => "test content")
      end
      get :index, :user_id => @req_user
      response.should have_selector("div.pagination")
      response.should have_selector("span.disabled", :content => "Previous")
      response.should have_selector("a", :href => "#{user_microposts_path(@req_user)}?page=2",
                                         :content => "2")
      response.should have_selector("a", :href => "#{user_microposts_path(@req_user)}?page=2",
                                           :content => "Next")
    end
  end

  describe "POST 'create'" do

    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :content => "" }
        @attr_reply = { :content => "blabla", :in_reply_to => 1000 }
      end

      it "should not create the micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should not create the reply" do
        lambda do
          post :create, :micropost => @attr
        end.should_not change(Micropost, :count)
      end

      it "should render the home page" do
        post :create, :micropost => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do

      before(:each) do
        @replied_user = Factory(:user, :email => Factory.next(:email))
        @attr = { :content => "Lorem ipsum" }
        @attr_reply = { :content => "Lorem ipsum", :in_reply_to => @replied_user.id }
      end

      it "should create the micropost" do
        lambda do
          post :create, :micropost => @attr
        end.should change(Micropost, :count).by(1)
      end

      it "should create the reply" do
        lambda do
          post :create, :micropost => @attr_reply
        end.should change(Micropost, :count).by(1)
      end

      it "should redirect to the home page" do
        post :create, :micropost => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash message for the micropost" do
        post :create, :micropost => @attr
        flash[:success].should =~ /micropost created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do

      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    describe "for an authorized user" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should destroy the micropost" do
        lambda do 
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
end

