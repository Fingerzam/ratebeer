require 'spec_helper'

describe "User" do
  include OwnTestHelper

  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  it "can add a beer" do 

  end
end
