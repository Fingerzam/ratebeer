require 'spec_helper'

describe Beer do
  let(:style) { FactoryGirl.create :style }
  let(:brewery) {FactoryGirl.create :brewery }
  it "is not saved without a name" do
    beer = Beer.create style_id: style.id, brewery_id: 1

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name: "test", brewery_id: 1

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is created with name, brewery and style" do
    beer = Beer.create name: "test", brewery_id: brewery.id, style_id: style.id

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end
end
