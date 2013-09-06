module AverageRating
  def average_rating
    raise "No ratings" if ratings.empty?
    numeric_ratings = ratings.map &:score
    sum = numeric_ratings.sum(:+)
    sum / ratings.length
  end
end
