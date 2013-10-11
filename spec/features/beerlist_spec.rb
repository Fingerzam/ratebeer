require 'spec_helper'

describe "Beerlist page" do
  before :all do
    self.use_transactional_fixtures = false
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  before :each do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start

    @brewery1 = FactoryGirl.create(:brewery, name: "Koff")
    @brewery2 = FactoryGirl.create(:brewery, name: "Schlenkerla")
    @brewery3 = FactoryGirl.create(:brewery, name: "Ayinger")
    @style1 = Style.create name: "Lager"
    @style2 = Style.create name: "Rauchbier"
    @style3 = Style.create name: "Weizen"
    @beer1 = FactoryGirl.create(:beer, name: "Nikolai", brewery: @brewery1,
                                style: @style1)
    @beer2 = FactoryGirl.create(:beer, name: "Fastenbier", brewery: @brewery2,
                                style: @style2)
    @beer3 = FactoryGirl.create(:beer, name: "Lechte Weisse", brewery: @brewery3,
                                style: @style3)
  end

  after :each do
    DatabaseCleaner.clean
  end

  after :all do
    self.use_transactional_fixtures = true
  end

  it "shows one known beer", js: true do
    visit beerlist_path
    expect(page).to have_content "Nikolai"
  end

  it "shows the beers in alphabetical order by name", js: true do
    visit beerlist_path
    correct_order({2 => "Fastenbier", 3 => "Lechte Weisse", 4 => "Nikolai"})
  end

  it "shows the beers ordered by name after clicking Name", js:true do
    correct_order_after_ordering({2 => "Fastenbier",
                                  3 => "Lechte Weisse",
                                  4 => "Nikolai"},
                                 "Name")
  end

  it "shows the beers ordered by style after clicking style", js:true do
    correct_order_after_ordering({2 => "Lager",
                                  3 => "Rauchbier",
                                  4 => "Weizen"},
                                 "Style")
  end

  it "shows the beers ordered by breweries after clicking brewery", js:true do
    correct_order_after_ordering({2 => "Ayinger",
                                  3 => "Koff",
                                  4 => "Schlenkerla"},
                                 "Brewery")
  end

  def correct_order_after_ordering(indexToName, order)
    visit beerlist_path
    click_link order
    correct_order(indexToName)
  end

  def correct_order(indexToName)
    indexToName.keys.each do |i|
      find('table').find("tr:nth-child(#{i})").should have_content(indexToName[i])
    end
  end
  
end
