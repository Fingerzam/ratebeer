class User < ActiveRecord::Base
  include AverageRating
  attr_accessible :username

  has_many :ratings
  has_many :beers, :through => :ratings
  has_many :memberships

  def to_s
    username
  end
end
