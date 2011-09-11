require 'digest'

class User < ActiveRecord::Base
	
	attr_accessor	:password
	
	attr_accessible :name, :email, :password, :password_confirmation
	
	has_many :microposts, :dependent => :destroy
	
	has_many :relationships, :foreign_key => :follower_id,	# original : "follower_id"
							 :dependent => :destroy
							 
	# :source parameter which explicitly tells Rails that the source
	# of the following array is the set of followed ids.
	has_many :following, :through => :relationships, :source => :followed
	
	has_many :reverse_relationships, :foreign_key => :followed_id, 
									 :class_name => "Relationship",
									 :dependent => :destroy
							
	# since Rails will automatically look for the foreign key follower_id in this case. 
	# I’ve kept the :source key to emphasize the parallel structure with the has_many :following
	# association, but you are free to leave it out.
	has_many :followers, :through => :reverse_relationships, :source => :follower
	
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :name, :presence => true,
					 :length   => { :maximum => 50 }

	validates :email, :presence => true,
					  :format	=> { :with => email_regex },
					  :uniqueness => { :case_sensitive => false }
	
	# Automatically create the virtual attribute 'password_confirmation'.	  
	validates :password, :presence => true,
						 :confirmation => true,
						 :length => { :within => 6..40 }
						 
	before_save :encrypt_password
	
	# The has_password? method will test whether a user has 
	# the same password as one submitted on a sign-in form
	# Return true if the user's password matches the submitted password.
	def has_password?(submitted_password)
		self.encrypted_password == encrypt(submitted_password)
	end
	
	# Use this method when signing users in to our site.
	# There are three cases to check: authenticate
	# (1) should return nil when no user exists with the given email address or
	# (2) should return the user object itself on success or
	# (3) should return nil when the email/password combination is invalid
	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
		# Handle the third case (password mismatch) implicitly, since in
		# that case we reach the end of the method, which automatically 
		# returns nil.
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end
	
	def following?(followed)
		relationships.find_by_followed_id(followed)
	end
	
	def follow!(followed)
		relationships.create!(:followed_id => followed.id)
	end
	
	def unfollow!(followed)
		relationships.find_by_followed_id(followed).destroy
	end
	
	def feed
		Micropost.from_users_followed_by(self)
	end
	
	private
	
		def encrypt_password
			# the object has not yet been saved to the database.
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
						 
end
