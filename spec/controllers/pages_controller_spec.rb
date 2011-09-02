require 'spec_helper'

describe PagesController do

	# Necessary for the title test to work.
	render_views

	describe "GET 'home'" do
		it "should be successful" do
			get 'home'
			response.should be_success
		end
		
		it "should have the right title" do
			get 'home'
			# Check to see that the content inside the <title></title> tags is
			# "Post Now | Home"
			response.should have_selector("title",
										  :content => "Post Now App | Home")
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
										  :content => "Post Now App | Contact")
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
        								  :content => "Post Now App | About")
        end
    end
end
