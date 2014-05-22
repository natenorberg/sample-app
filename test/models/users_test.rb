require 'test_helper'

class UsersTest < ActiveSupport::TestCase

	def setup
		# Setup user with valid input
		@user = User.new
		@user.name = "Some Guy"
		@user.email = "fake@fake.com"
		@user.password = "password1"
		@user.password_confirmation = "password1"
	end

  	test "user should respond to fields" do
    	assert(@user.respond_to?(:name), "User should respond to name")
    	assert(@user.respond_to?(:email), "User should respond to email")
    	assert(@user.respond_to?(:password_digest), "User should respond to password_digest")
    	assert(@user.respond_to?(:password), "User should respond to password")
    	assert(@user.respond_to?(:password_confirmation), "User should respond to password_confirmation")
  	end

  	test "user should not save without name" do
  		@user.name = ""
  		assert_not(@user.valid?, "Saved user without a name")
  	end

  	test "user should not save without email" do
  		@user.email = ""
  		assert_not(@user.valid?, "Saved user without an email")
  	end

  	test "user should not save without password" do
  		# Make password and confirmation match so that the empty string causes the error
  		@user.password = @user.password_confirmation = ""  
  		assert_not(@user.valid?, "Saved user without a password")
  	end

  	test "name should not be longer than 50 characters" do
  		@user.name = "n" * 51
  		assert_not(@user.valid?, "Saved user with name.length>50")
  	end

  	test "email should be valid" do
  		invalid_addresses = %w[user@foo,com user_at_foo.org example.user@foo]
  		valid_addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		invalid_addresses.each do |invalid_address|
  			@user.email = invalid_address
  			assert_not(@user.valid?, "#{invalid_address} is not a valid address")
  		end
  		valid_addresses.each do |valid_address|
  			@user.email = valid_address
  			assert(@user.valid?, "#{valid_address} is a valid address")
  		end
  	end

  	test "email should be unique" do
  		user_with_same_email = @user.dup
  		user_with_same_email.save
  		assert_not(@user.valid?, "User should not be able to save a duplicate email")

  		# Should also not be case sensitive
  		@user.email = user_with_same_email.email.upcase
  		assert_not(@user.valid?, "Email shouldn't be case sensitive")
  	end

  	test "email should be saved lowercase" do
  		mixed_case_email = "Test@tESt.Test"
  		@user.email = mixed_case_email
  		@user.save
  		assert(@user.reload.email == mixed_case_email.downcase, "Email was not saved lowercase")
  	end

  	test "password should match confirmation" do
  		@user.password_confirmation = "wrongpassword"
  		assert_not(@user.valid?, "Saved user with password confirmation mismatch")
  	end

  	test "password should be at least 6 characters" do
  		@user.password_confirmation = @user.password = "abcde"
  		assert_not(@user.valid?, "Saved user with too short a password")
  	end

end
