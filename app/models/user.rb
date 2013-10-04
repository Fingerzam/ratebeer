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
    ratings.sort_by { |r| r.score }.last.beer
  end

  def favorite_style
    styles = beers.map &:style
    styles.uniq!

    styles.max_by &method(:average_rating_for_style)
  end

  def average_rating_for_style(style)
    ratings_with_style = ratings.select { |r| r.beer.style == style }
    scores = ratings_with_style.map &:score
    average scores
  end

  def average(list)
    sum = list.inject(:+)
    sum/list.length
  end

  def favorite_brewery
    return nil if beers.empty?
    breweries = beers.map &:brewery
    breweries.max_by &method(:average_rating_for_breweries)
  end

  def average_rating_for_breweries(brewery)
    ratings_with_brewery = ratings.select {|r| r.beer.brewery == brewery}
    scores = ratings_with_brewery.map &:score
    average scores
  end
end
