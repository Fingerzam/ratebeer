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
