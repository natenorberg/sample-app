require 'spec_helper'

def sign_in(user)
  visit login_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"

  cookies[:remember_token] = user.remember_token
end

describe "User pages" do

	subject{page}

  describe "index", type: :request do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end
    let(:header_text) {"All users"}

    it {should have_title(header_text)}
    it {should have_selector('h1', header_text)}

    describe "pagination" do

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { first(:link, 'delete').click }.to change(User, :count) .by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end

      describe "as a non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(root_path) }
        end
      end
    end
  end

	describe "signup page" do
		before{ visit signup_path }

		it { should have_selector('h1', :text => 'Sign Up') }
		it { should have_title("Sign Up") }
	end

	describe "signup", type: :request do
		before{visit signup_path}
		let(:submit) {"Create my account"}

		describe "with invalid information" do
		  it "should not create a user" do
        expect {click_button submit}.not_to change(User, :count)
      end

      describe "after submission" do
        before {click_button submit}

        it {should have_title("Sign Up")}
        it {should have_selector('h1', text: "Sign Up")}
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",                  with: "Test User"
        fill_in "Email",                 with: "user@test.com"
        fill_in "Password",              with: "password1"
        fill_in "Password confirmation", with: "password1"
      end

      it "should create a user" do
        expect {click_button submit}.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before {click_button submit}
        let(:user) {User.find_by_email('user@test.com')}

        it {should have_title(user.name)}
        it {should have_selector('div.alert.alert-success', text: "Welcome")}
      end
    end
	end

	describe "profile page" do
		let(:user) {FactoryGirl.create(:user)}
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Hello") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "World") }
		before{visit user_path(user)}

		it{should have_selector('h1', text: user.name)}
		it{should have_title(user.name)}

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
	end

  describe "edit", type: :request do
    let(:user) { FactoryGirl.create(:user)}
    before do 
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it {should have_selector('h1', text: "Update your profile")}
      it {should have_title("Edit user")}
      it {should have_link('change', href: 'http://gravatar.com/emails')}
    end

    describe "with invalid information" do
      before {click_button "Save Changes"}

      it {should have_content('error')}
    end

    describe "with valid information" do
      let(:new_name) { "New Name"}
      let(:new_email) {"new@example.com"}
      before do
        fill_in "Name",                  with: new_name
        fill_in "Email",                 with: new_email
        fill_in "Password",              with: user.password
        fill_in "Password confirmation", with: user.password
        click_button "Save Changes"
      end

      it {should have_title(new_name)}
      it {should have_link('Profile', href: user_path(user))}
      it {should have_selector('div.alert.alert-success')}
      it {should have_link('Sign out', href: logout_path)}
      specify {user.reload.name.should == new_name}
      specify {user.reload.email.should == new_email}
    end
  end
end