class UsersController < ApplicationController

	def show
		@user = User.find(params[:id])
		@title = @user.name
	end	
	
    def new
    	@user = User.new
  	    @title = "Sign up"
    end
    
    def create
    	# Equaliert to @user = User.new(:name => "***", :email => "***", 
    	# 			   :password => "***", :password_confirmation => "***")
    	@user = User.new(params[:user])
    	if @user.save
    		# Handle a successful save.
    		sign_in @user
    		flash[:success] = "Welcome to the Post Now App!"
    		redirect_to @user
    	else
    		@title = "Sign up"
    		render 'new'
    	end
    end

end
