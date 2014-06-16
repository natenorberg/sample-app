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
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Microposts controller" do
        
        describe "submitting the create action", type: :request do
          before { post microposts_path }
          specify { response.should redirect_to(login_path) }
        end

        describe "submitting the delete action", type: :request do
          before do
            micropost = FactoryGirl.create(:micropost)
            delete micropost_path(micropost)
          end
          specify { response.should redirect_to(login_path) }
        end
      end

      describe "in the Users controller" do

        describe "visiting the user index" do
          before {visit users_path}
          it {should have_title('Sign in')}
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_title("Sign in") }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_title("Sign in") }
        end
      end

      describe "in the Relationships controller", type: :request do
        
        describe "submitting the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(login_path)}
        end

        describe "submitting the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(login_path) }
        end
      end
    end
  end
end