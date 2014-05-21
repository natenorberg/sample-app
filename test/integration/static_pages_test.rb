require 'test_helper'

class StaticPagesTest < ActionDispatch::IntegrationTest

	def setup
		@base_title = "Ruby on Rails Tutorial Sample App"
	end

	test "home page has header 'Sample App'" do
		get root_path
		assert_response :success
		assert_select 'h1', "Welcome to the Sample App"
		assert_select 'title', :text => @base_title
	end

	test "help page has header 'Help'" do
		get help_path
		assert_response :success
		assert_select 'h1', "Help"
		assert_select 'title', :text => @base_title + " | Help"
	end

	test "about page has header 'About Us'" do
		get about_path
		assert_response :success
		assert_select 'h1', "About Us"
		assert_select 'title', :text => @base_title + " | About Us"
	end

	test "contact page has header 'Contact'" do
		get contact_path
		assert_response :success
		assert_select 'h1', "Contact"
		assert_select 'title', :text => @base_title + " | Contact"
	end
end
