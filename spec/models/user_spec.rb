require 'spec_helper'

describe "User" do
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
      create_beers_with_ratings 10, 20, 15, 7, 9, user
      best = create_beer_with_rating 25, user

      expect(user.favorite_beer).to eq(best)
    end
  end


  describe "favorite style" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method favorite_style" do
      user.should respond_to :favorite_style
    end

    it "with no ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style with the highest average rating" do
      lambic = FactoryGirl.create :style, name: "Lambic"
      lager = FactoryGirl.create :style, name: "Lager"
      create_beers_with_ratings_and_style(11,12,13, lager, user)
      create_beers_with_ratings_and_style(21,32,23, lambic, user)

      expect(user.favorite_style).to eq(lambic)
    end
  end

  describe "favorite_brewery" do
    let(:user) { FactoryGirl.create(:user) }

    it "has method favorite_brewery" do
      user.should respond_to :favorite_brewery
    end

    it "without ratings does not have a favorite brewery" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "with rated beers from only one brewery has that brewery as the favorite" do
      beer = create_beer_with_rating(14, user)
      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "with rated beers from multiple breweries has the one with highest average score as the favorite" do
      brewery1 = FactoryGirl.create(:brewery)
      brewery2 = FactoryGirl.create(:brewery)
      create_beers_with_ratings_and_brewery(11,12,13, brewery1, user)
      create_beers_with_ratings_and_brewery(21,22,13, brewery2, user)

      expect(user.favorite_brewery).to eq(brewery2)
    end
  end

  def create_beer(score, brewery, style, user)
    beer = create_beer_without_brewery(score,style,user)
    beer.brewery = brewery
    beer.save
    beer
  end

  def create_beer_without_brewery(score, style, user)
    beer = FactoryGirl.create(:beer, style: style)
    FactoryGirl.create(:rating, score: score, beer: beer, user: user)
    beer
  end

  def create_beers_with_ratings_and_brewery(*scores, brewery, user)
    style = FactoryGirl.create :style
    for score in scores
      create_beer(score, brewery, style, user)
    end
  end

  def create_beer_with_rating_and_brewery(score, brewery, user)
    style = FactoryGirl.create :style
    create_beer(score, brewery, style, user)
  end

  alias_method :create_beer_with_rating_and_style, :create_beer_without_brewery

  def create_beers_with_ratings_and_style(*scores, style, user)
    for score in scores
      create_beer_with_rating_and_style(score, style, user)
    end
  end

  def create_beers_with_ratings(*scores, user)
    style = FactoryGirl.create :style
    create_beers_with_ratings_and_style(*scores, style, user)
  end

  def create_beer_with_rating(score, user)
    style = FactoryGirl.create :style
    create_beer_without_brewery(score, style, user)
  end
end
