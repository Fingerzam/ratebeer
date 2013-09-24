require 'spec_helper'

describe "User" do
  include OwnTestHelper

  before :each do
    @user = FactoryGirl.create :user
  end

  describe "who has signed up" do
    describe "and signed up" do
      before :each do
        sign_in 'Pekka', 'foobar1'
      end

      it "can sign in with right credentials" do
        expect(page).to have_content "Welcome back!"
        expect(page).to have_content "Pekka"
      end

      it "without ratings has no favorites" do
        expect(page).not_to have_content("Favorite")
      end

      it "with ratings should display favorites" do
        brewery = FactoryGirl.create :brewery
        beer = FactoryGirl.create :beer, name: "Beer", brewery: brewery
        rating = FactoryGirl.create :rating, beer: beer, score: 10, user: @user

        visit user_path(@user.id)
        expect(page).to have_content("Favorite")
      end
    end

    it "is redirected back to sign in form with wrong credentials" do
      sign_in 'Pekka', 'wrong'

      expect(current_path).to eq(signin_path)
      expect(page).to have_content "username and password do not match"
    end


    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with: "Brian")
      fill_in('user_password', with: "secret55")
      fill_in('user_password_confirmation', with: "secret55")

      expect {
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
  end
end
