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

  def self.active_users(n)
    User.all
        .sort_by{|u| u.ratings.count}
        .reverse
        .take(3)
        .select{|u| u.ratings.count > 0}
  end

  def to_s
    username
  end

  def confirmed_clubs
    BeerClub.joins(:memberships).where('memberships.user_id' => id,
                                       'memberships.confirmed' => true)
  end

  def unconfirmed_clubs
    BeerClub.joins(:memberships).where('memberships.user_id' => id,
                                       'memberships.confirmed' => [false, nil])
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by(&:score).last.beer
  end

  def rated category
    ratings.map {|r| r.beer.send(category) }.uniq
  end

  def average(list)
    sum = list.inject(0.0, :+)
    sum/[1,list.length].max
  end

  def rating_average_for category, instance
    ratings_of_category = ratings.select {|r| r.beer.send(category) == instance}
    return 0 if ratings_of_category.empty?
    average ratings_of_category.map(&:score)
  end

  def favorite category
    grouped = ratings.group_by {|r| r.beer.send category}.select{|_, ratings| not ratings.nil? and ratings.count > 0}
    return nil if grouped.count == 0
    grouped.max_by{|_, ratings| average(ratings.map(&:score))}.first
    #rated(category).max_by {|instance| rating_average_for(category, instance)}
  end

  [:style,:brewery].each do |category|
    define_method("favorite_#{category}") {favorite category}
  end
end
