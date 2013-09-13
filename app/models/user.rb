class User < ActiveRecord::Base
  include AverageRating
  attr_accessible :username

  has_many :ratings
  has_many :beers, :through => :ratings
  has_many :beer_clubs, through: :memberships
end
