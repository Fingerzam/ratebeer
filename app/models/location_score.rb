class LocationScore
  attr_accessor :overall, :selection, :service, :atmosphere, :food,
                :reviewcount, :fbscore, :fbcount

  def self.rendered_fields
    [:overall, :selection, :service, :atmosphere, :food,:reviewcount,
     :fbscore, :fbcount]
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
