require 'test_helper'

class UserPagesTest < ActionDispatch::IntegrationTest
  
	test "signup page" do
		get signup_path
		assert_response :success
		assert_select 'h1', text: "Sign Up"
		assert_select 'title', text: full_title("Sign Up")
	end

	test "profile page" do
		create_test_user
		get user_path(@user)
		assert_response :success
		assert_select 'h1', text: @user.name
		assert_select 'title', text: full_title(@user.name)
	end

	def create_test_user
		name = "Nate Norberg"
		email = "natenorberg@gmail.com"
		password = "password1"
		@user = User.new(name: name, email: email, password: password, password_confirmation: password)
		@user.save
	end

end
