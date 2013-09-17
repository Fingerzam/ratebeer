require 'spec_helper'

describe "Breweries page" do
  it "should not have any breweries before they have been created" do
    visit breweries_path
    expect(page).to have_content 'Listing breweries'
    expect(page).to have_content 'number of breweries 0'
  end
end
