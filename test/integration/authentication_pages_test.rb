require 'test_helper'

class AuthenticationPagesTest < ActionDispatch::IntegrationTest
  
	test "sign in page" do
		get login_path
		assert_response :success
		assert_select 'h1', "Sign in"
		assert_select 'title', full_title("Sign in")
	end

end
