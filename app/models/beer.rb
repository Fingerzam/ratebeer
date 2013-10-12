class Beer < ActiveRecord::Base
  include AverageRating
  extend TopRated

  attr_accessible :brewery_id, :name, :style_id

  validates_length_of :name, minimum: 1
  validates_presence_of :style

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, :dependent => :destroy
  has_many :raters, through: :ratings, source: :user

  def to_s
    "#{name} (#{brewery.name})"
  end
end
