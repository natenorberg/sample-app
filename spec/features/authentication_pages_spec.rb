require 'spec_helper'

describe "Authentication" do

	subject{page}

	describe "login page" do
		before{visit login_path}

		it{should have_selector('h1', text: "Sign in")}
		it{should have_title("Sign in")}
	end

	describe "signin" do
		before{visit login_path}

		describe "with invalid information" do
			before {click_button "Sign in"}

			it{should have_title("Sign in")}
			it{should have_selector('div.alert.alert-danger', text: "Invalid")}

      describe "after visiting another page" do
        before{click_link "Home"}
        it {should_not have_selector('div.alert.alert-danger')}
      end
		end

    describe "with valid information", type: :request do
      let(:user) {FactoryGirl.create(:user)}
      before {sign_in user}

      it {should have_title(user.name)}
      it {should have_link('Profile', href: user_path(user))}
      it {should have_link('Settings', href: edit_user_path(user))}
      it {should have_link('Sign out', href: logout_path)}

      it {should_not have_link('Sign in', href: login_path)}
    end
	end

  describe "authorization" do

    describe "for non-signed-in users" do

      describe "in the Users controller" do

        describe "visiting the user index" do
          before {visit users_path}
          it {should have_title('Sign in')}
        end
      end
    end
  end
end