class User < ActiveRecord::Base
  include AverageRating
  attr_accessible :username, :password, :password_confirmation, :admin
  has_secure_password

  validates_uniqueness_of :username
  validates_length_of :password, minimum: 4
  validates_length_of :username, minimum: 3, maximum: 15
  validates_each :password do |record, attr, value|
    if /\A[a-zA-Z]*\Z/ =~ value
      record.errors.add(attr, 'must contain numbers of special characters')
    end
  end

  has_many :ratings, dependent: :destroy
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

  def to_s
    username
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by(&:score).last.beer
  end

  def rated category
    ratings.map {|r| r.beer.send(category) }.uniq
  end

  def average(list)
    sum = list.inject(:+)
    sum/list.length
  end

  def rating_average_for category, instance
    ratings_of_category = ratings.select {|r| r.beer.send(category) == instance}
    return 0 if ratings_of_category.empty?
    average ratings_of_category.map(&:score)
  end

  def favorite category
    rated(category).max_by {|instance| rating_average_for(category, instance)}
  end

  [:style,:brewery].each do |category|
    define_method("favorite_#{category.to_s}".to_sym) {favorite category}
  end
end
