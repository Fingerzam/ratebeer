class Beer < ActiveRecord::Base
  include AverageRating
  attr_accessible :brewery_id, :name, :style

  belongs_to :brewery
  has_many :ratings, :dependent => :destroy
  has_many :users, :through => :ratings

  def to_s
    "#{name} (#{brewery.name})"
  end
end
