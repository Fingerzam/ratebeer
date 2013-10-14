# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

b1 = Brewery.create :name => "Koff", :year => 1897
b2 = Brewery.create :name => "Malmgard", :year => 2001
b3 = Brewery.create :name => "Weihenstephaner", :year => 1042

lager = Style.create name: "Lager"
pale_ale = Style.create name: "Pale Ale"
porter = Style.create name: "Porter"
weizen = Style.create name: "Weizen"

b1.beers.create :name => "Iso 3", style_id: lager.id
b1.beers.create :name => "Karhu", style_id: lager.id
b1.beers.create :name => "Tuplahumala", style_id: lager.id
b2.beers.create :name => "Huvila Pale Ale", style_id: pale_ale.id
b2.beers.create :name => "X Porter", style_id: porter.id
b3.beers.create :name => "Hefezeizen", style_id: weizen.id
b3.beers.create :name => "Helles", style_id: lager.id

users = 100
breweries = 50
beers_in_brewery = 50
ratings_per_user = 30

(1..users).each do |i|
  User.create :username => "user_#{i}", :password => "passwd1", :password_confirmation => "passwd1"
end

(1..breweries).each do |i|
  Brewery.create :name => "brewery_#{i}", :year => 1900, :active => true
end

bulk = Style.create :name => "bulk", :description => "cheap, not much taste"

Brewery.all.each do |b|
  n = rand(beers_in_brewery)
  (1..n).each do |i|
    beer = Beer.create :name => "beer #{b.id} -- #{i}"
    beer.style = bulk
    b.beers << beer
  end
end

User.all.each do |u|
  n = rand(ratings_per_user)
  beers = Beer.all.shuffle
  (1..n).each do |i|
    r = Rating.new :score => (1+rand(50))
    beers[i].ratings << r
    u.ratings << r
  end
end
