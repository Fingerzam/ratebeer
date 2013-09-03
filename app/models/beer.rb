class Beer < ActiveRecord::Base
  attr_accessible :brewery_id, :name, :style

  belongs_to :brewery
  has_many :ratings

  def avarage_rating
      return 0 if ratings.empty?

      numeric_ratings = ratings.map &:score
      sum = numeric_ratings.inject(:+)
      sum / numeric_ratings.size
  end
end
