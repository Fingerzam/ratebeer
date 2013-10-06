class BeermappingAPI
  def self.places_in city
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty .get "#{url}#{city.gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map {|place| Place.new(place) }
  end

  def self.key
    "9ff575cbe897a2650dfd81a6eb3e4a8b"
  end
end
