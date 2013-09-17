class User < ActiveRecord::Base
  include AverageRating
  attr_accessible :username, :password, :password_confirmation
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
end
