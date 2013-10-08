class Beer < ActiveRecord::Base
  include AverageRating
  attr_accessible :brewery_id, :name, :style_id

  validates_length_of :name, minimum: 1

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, :dependent => :destroy
  has_many :raters, through: :ratings, source: :user

  def to_s
    "#{name} (#{brewery.name})"
  end
end
