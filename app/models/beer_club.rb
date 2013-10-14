class BeerClub < ActiveRecord::Base
  attr_accessible :city, :founded, :name

  scope :unconfirmed, -> {User.joins(:memberships).where(memberships: [confirmed: [nil, false], beer_club_id: id])}

  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def confirmed
    User.joins(:memberships).where('memberships.confirmed' => true,
                                   'memberships.beer_club_id' => id)
    #User.joins(:memberships).where(confirmed: true, beer_club_id: id)
  end

  def unconfirmed
    User.joins(:memberships).where('memberships.confirmed' => false,
                                   'memberships.beer_club_id' => id)
  end

  def application_for(user)
    Membership.where(confirmed: [nil, false], beer_club_id: id, user_id: user.id).first
  end

  def confirmed_member?(user)
    User.joins(:memberships).where(id: user.id,
                                   'memberships.beer_club_id' => id,
                                   'memberships.confirmed' => true)
                            .exists?
  end

  def to_s
    "#{name} (#{city})"
  end
end
