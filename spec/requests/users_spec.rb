require 'spec_helper'

describe "Users" do

	describe "signup" do
	
		describe "failure" do
		
			it "should not make a new user" do
				# The lambda to verify that the code inside the lambda block 
				# doesn’t change the value of User.count.
				lambda do
					visit signup_path
					fill_in "Name",			:with => ""
					fill_in "Email",		:with => ""
					fill_in "Password", 	:with => ""
					fill_in "Confirmation",	:with => ""
					click_button		
					response.should render_template('users/new')
					# <div id="error_explanation">...</div>
					response.should have_selector("div#error_explanation")
				end.should_not change(User, :count)
			end
		end

		describe "success" do
			
			it "should make a new user" do
				lambda do
					visit signup_path
					fill_in "Name",			:with => "test user"
					fill_in "Email",		:with => "testuser3@test.com"
					fill_in "Password",		:with => "Password01!"
					fill_in "Confirmation",	:with => "Password01!"
					click_button
					response.should have_selector("div.flash.success",
												  :content => "Welcome to the Post Now App!")
					response.should render_template('users/show')
				end.should change(User, :count).by(1)
			end
		end
	end
end
