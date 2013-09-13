class BeerClub < ActiveRecord::Base
  attr_accessible :city, :founded, :name

  has_many :members, through: :memberships, source: :user
end
