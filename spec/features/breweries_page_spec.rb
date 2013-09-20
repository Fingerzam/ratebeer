require 'spec_helper'

describe "Breweries page" do
  it "should not have any breweries before they have been created" do
    visit breweries_path
    expect(page).to have_content 'Listing breweries'
    expect(page).to have_content 'number of breweries 0'
  end

  describe "when breweries exist" do
    before :each do
      @breweries = ["Koff", "Karjala", "Schlenkerla"]
      year = 1896
      for brewery in @breweries
        FactoryGirl.create(:brewery, name: brewery, year: year+= 1)
      end

      visit breweries_path
    end

    it "lists the existing breweries and their total number" do
      expect(page).to have_content "number of breweries #{@breweries.count}"

      for brewery in @breweries
        expect(page).to have_content brewery
      end
    end

    it "allows user to navigate to page of a Brewery" do
      click_link "Koff"

      expect(page).to have_content "Koff"
      expect(page).to have_content "Established year 1897"
    end
  end
end
