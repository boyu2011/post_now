require 'spec_helper'

describe UsersController do

	render_views
	
	describe "GET 'show'" do
		
		before(:each) do
			@user = Factory(:user)
		end
		
		it "should be successful" do
			get :show, :id => @user.id
			response.should be_success
		end
		
		it "should find the right user" do
			get :show, :id => @user
			# The assigns method takes in a symbol argument and returns  the 
			# value of the corresponding instance variable in the controller action.
			# [In the show action of the Users controller.]
			assigns(:user).should == @user
		end
		
		it "should have the right title" do
			get :show, :id => @user.id
			response.should have_selector("title", :content => @user.name)
		end
		
		it "should include the user's name" do
			get :show, :id => @user.id
			response.should have_selector("h1", :content => @user.name)
		end
		
		it "should have a profile image" do
			get :show, :id => @user.id
			# h1>img makes sure that the img tag is inside the h1 tag.
			response.should have_selector("h1>img", :class => "gravatar")
		end
		
	end
	
	describe "GET 'new'" do
	  	it "should be successful" do
			get 'new'
		    	response.should be_success
		    end
		  
		it "should have the right title" do
		  	get 'new'
		  	response.should have_selector("title", :content => "Post Now App | Sign up")
		end
	end
	
	describe "POST 'create'" do
		
		describe "failure" do
			
			before(:each) do
				@attr = { :name => "", :email => "", :password => "", 
						  :password_confirmation => "" }
			end
			
			# a failed create action doesn’t create a user in the database
			it "should not create a user" do
				# Check it doesn't change the User count.
				lambda do
					post :create, :user => @attr
				# change method to return the number of users in the database.
				end.should_not change(User, :count)
			end
			
			it "should have the right title" do
				post :create, :user => @attr
				response.should have_selector("title", 
											  :content => "Post Now App | Sign up")
			end
			
			it "should render the new page" do
				post :create, :user => @attr
				response.should render_template('new')
			end
		end
		
		describe "success" do
			
			before(:each) do
				@attr = { :name => "new user", :email => "newuser@user.com",
						  :password => "Password01!", :password_confirmation => "Password01!" }
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
				flash[:success].should =~ /Welcome to the Post Now App!/i
			end
			
			it "should sign the user in" do
				post :create, :user => @attr
				controller.should be_signed_in
			end
		end
		
	end
	

end
