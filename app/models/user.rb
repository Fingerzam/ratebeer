class User < ActiveRecord::Base
  include AverageRating
  attr_accessible :username

  has_many :ratings, dependent: :destroy
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def to_s
    username
  end
end
