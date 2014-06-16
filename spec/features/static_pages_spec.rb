require 'spec_helper'

describe "Static pages" do

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('h1', text: heading) }
		it { should have_title(heading) }
	end

	describe "Home page", type: :request do
		before { visit root_path }

		let(:heading) { 'Sample App' }
		it_should_behave_like "all static pages"
		it { should_not have_selector('title', text: '| Home') }

    describe "for logged in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user:user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user:user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the users feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 follower",  href: followers_user_path(user)) }
      end
    end
	end

	describe "Help page" do
		before { visit help_path }

	let(:heading) { 'Help' }
	it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }

	let(:heading) { 'About' }
	it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }

	let(:heading) { 'Contact' }
	it_should_behave_like "all static pages"
	end

	it "should have the right links on the layout" do 
    visit root_path
    click_link "About"
    page.should have_title 'About Us'
    click_link "Help"
    page.should # fill in 
    click_link "Contact"
    page.should # fill in 
    click_link "Home"
    click_link "Sign up now!"
    page.should # fill in 
    click_link "Sample App"
    page.should # fill in 
	end 
end
