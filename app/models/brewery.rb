class Brewery < ActiveRecord::Base
  include AverageRating
  attr_accessible :name, :year

  has_many :beers
  has_many :ratings, through: :beers
end
