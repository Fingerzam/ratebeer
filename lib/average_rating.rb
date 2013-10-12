module AverageRating
  def average_rating
    return 0 if ratings.empty?
    numeric_ratings = ratings.map &:score
    sum = numeric_ratings.sum(:+)
    sum / ratings.length
  end

end

module TopRated
  def top n
    all.sort_by(&:average_rating).reverse.take n
  end
end
