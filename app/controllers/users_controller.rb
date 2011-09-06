class UsersController < ApplicationController

	before_filter :authenticate, :only => [:index, :edit, :update]
	
	before_filter :correct_user, :only => [:edit, :update]
	
	before_filter :admin_user, :only => :destroy
	
	def index
		@title = "All users"
		# Here the :page parameter comes from params[:page], 
		# which is generated automatically by will_paginate
		@users = User.paginate(:page => params[:page])
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(:page => params[:page])
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
    
    def edit
		# the correct_user before filter defines @user 
		# so we can omit it from the edit action
		@user = User.find(params[:id])
		@title = "Edit user"
	end
	
	def update
		# the correct_user before filter defines @user 
		# so we can omit it from the edit action
		@user = User.find(params[:id])
		if @user.update_attributes(params[:user])
			flash[:success] = "Profile updated."
			redirect_to @user
		else
			@title = "Edit user"
			render 'edit'
		end
	end
	
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "user destroyed."
		redirect_to users_path
	end
	
	private
	
		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_path) unless current_user?(@user)
		end
		
		def admin_user
			redirect_to(root_path) unless current_user.admin?
		end
end
