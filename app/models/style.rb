class Style < ActiveRecord::Base
  include AverageRating
  extend TopRated
  attr_accessible :description, :name

  has_many :beers
  has_many :ratings, through: :beers

  def <=>(other)
    name <=> other.name
  end

  def to_s
    name
  end
end
