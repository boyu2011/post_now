class Relationship < ActiveRecord::Base

	# followed_id should be accessible, since users 
	# will create relationships through the web.
	attr_accessible :followed_id
	
	# Rails infers the names of the foreign keys from the corresponding symbols
	# (i.e., follower_id from :follower, and followed_id from :followed)
	
	belongs_to :follower, :class_name => "User"
	
	belongs_to :followed, :class_name => "User"
	
	validates :follower_id, :presence => true
	
	validates :followed_id, :presence => true
	
end
