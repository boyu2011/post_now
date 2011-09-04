# By using the symbol ':user', we get Factory Girl to simulate the User model.
# It is convenient way to define a user object and insert it into our test database.

Factory.define :user do |user|
	user.name					"bob"
	user.email					"boyu2011@gmail.com"
	user.password				"Password01!"
	user.password_confirmation	"Password01!"
end

Factory.sequence :email do |n|
	"person-#{n}@postnow.com"
end

