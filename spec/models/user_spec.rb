require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username: "Pekka"
    user.username.should == "Pekka"
  end

  it "is not saved without a proper password" do
    user = User.create username: "Pekka"
    
    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "is not saved and is not valid when" do
    it "password is too short" do
      user = User.create username: "Pekko", password: "asd", password_confirmation: "asd"

      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end

    it "password contains only letters" do
      user = User.create username: "Test", password: "secret", password_confirmation: "secret"

      expect(user.valid?).to be(false)
      expect(User.count).to eq(0)
    end
  end


  describe "with a proper password" do
    let(:user) { FactoryGirl.create(:user) }

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating1)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end


  describe "favorite beer" do
    let(:user) { FactoryGirl.create(:user) }
    
    it "has a method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, beer: beer, user: user)
      
      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating 10, user
      best = create_beer_with_rating 25, user
      create_beer_with_rating 7, user

      expect(user.favorite_beer).to eq(best)
    end
  end

  def create_beer_with_rating(score, user)
    beer = FactoryGirl.create(:beer)
    FactoryGirl.create(:rating, score: score, beer: beer, user: user)
    beer
  end
end
