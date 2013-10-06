require 'spec_helper'

describe "Places" do
  it "shows a place if one is returned by the API" do
    BeermappingAPI.stub(:places_in).with("kumpula").and_return([Place.new(name: "Oljenkorsi")])

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "shows all places if multiple returned by the API" do
    BeermappingAPI.stub(:places_in)
                  .with("arabia")
                  .and_return([Place.new(name: "Oljenkorsi"), Place.new(name: "Olotila")])

    visit places_path
    fill_in('city', with: 'arabia')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Olotila"
  end
end
