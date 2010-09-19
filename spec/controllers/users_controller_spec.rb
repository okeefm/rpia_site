require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
     it "should be successful" do
       get :new
       response.should be_success
      end
   
      it "should have the right title" do
        get :new
        response.should have_selector("title", :content => "Sign up")
      end
    
      it "should have a name field" do
        get :new
        response.should have_selector("input[name='user[name]'][type='text']")
      end

      it "should have an email field" do
        get :new
        response.should have_selector("input[name='user[email]'][type='text']")
      end

      it "should have a username field" do
        get :new
        response.should have_selector("input[name='user[username]'][type='text']")
      end

      it "should have an address field" do
        get :new
        response.should have_selector("input[name='user[address]'][type='text']")
      end

      it "should have a password field" do
        get :new
        response.should have_selector("input[name='user[password]'][type='password']")
      end

      it "should have a password confirmation field" do
        get :new
        response.should have_selector("input[name='user[password_confirmation]'][type='password']")
      end
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end
  end

  describe "POST 'create'" do

    describe "failure" do
      
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => "", :address => "", :username => "" }
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
 
      it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar", :username => "foobar", :address => "1234 Anywhere, Anytown USA" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to RPI Ambulance/i
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end
  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in-users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        Factory(:user, :username => "okeefm2")
        Factory(:user, :username => "okeefm3")
        
        30.times do
          Factory(:user, :username => Factory.next(:username))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        User.paginate(:page => 1).each do |user|
          response.should have_selector('li', :content => user.name)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => "Previous")
        response.should have_selector('a', :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector('a', :href => "/users?page=2",
                                           :content => "Next")
      end
      
      it "should have delete links for admins" do
        @user.toggle!(:admin)
        other_user = User.all.second
        get :index
        response.should have_selector('a', :href => user_path(other_user),
                                           :content => "delete")
      end

      it "should not have delete links for non-admins" do
        other_user = User.all.second
        get :index
        response.should_not have_selector('a', :href => user_path(other_user),
                                               :content => "delete")
      end
    end
  end
describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :username => "beepbopboop", :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
end
