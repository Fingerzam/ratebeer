require 'spec_helper'

describe Style do
  describe "when initialized with name Lager and description lager..." do
    subject { Style.create name: "Lager", description: "lager..." }

    its(:name) {should eq("Lager")}
    its(:description) {should eq("lager...")}
  end
end
