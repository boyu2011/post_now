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

end
