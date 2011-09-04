require 'faker'

namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		admin = User.create!(:name => "test user",
							 :email => "test@postnow.com",
							 :password => "Password01!",
							 :password_confirmation => "Password01!")
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name		# generate fake name
			email = "test-#{n+1}@postnow.com"
			password = "Password01!"
			User.create!(:name => name,
						 :email => email,
						 :password => password,
						 :password_confirmation => password)
		end
	end
end
