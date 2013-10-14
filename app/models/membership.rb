class Membership < ActiveRecord::Base
  attr_accessible :beer_club_id, :user_id, :confirmed

  belongs_to :user
  belongs_to :beer_club
end
