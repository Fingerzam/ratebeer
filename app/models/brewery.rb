class Brewery < ActiveRecord::Base
  include AverageRating
  attr_accessible :name, :year

  validates_length_of :name, minimum: 1
  validates_numericality_of :year, { greater_than_or_equal_to: 1042,
                                     only_integer: true }
  validates_each :year do |record, attr, value|
    if value > Time.now.year
      record.errors.add(attr, 'cannot be in the future')
    end
  end

  has_many :beers
  has_many :ratings, through: :beers

  def <=> other
    name <=> other.name
  end
end
