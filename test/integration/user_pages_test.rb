require 'test_helper'

class UserPagesTest < ActionDispatch::IntegrationTest
  
	test "signup page" do
		get signup_path
		assert_response :success
		assert_select 'h1', text: "Sign Up"
		assert_select 'title', text: full_title("Sign Up")
	end

end
