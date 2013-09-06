class User < ActiveRecord::Base
  include AverageRating
  attr_accessible :username

  has_many :ratings
end
