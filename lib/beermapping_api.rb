class BeermappingAPI
  def self.places_in city
    Place
    Time
    city = city.downcase

    Rails.cache.fetch({city: city}, expires_in: 1.hour) do
      fetch_places_in(city)
    end
  end

  def self.location id
    Place
    Time

    Rails.cache.fetch({location: id}, expires_in: 1.hour) do
      fetch_location_by_id id
    end
  end

  def self.location_score id
    LocationScore
    Time

    Rails.cache.fetch({location_score: id}, expores_in: 1.hour) do
      fetch_location_score id
    end
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"
    response = HTTParty .get "#{url}#{city.gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map {|place| Place.new(place) }
  end

  def self.fetch_location_by_id id
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"
    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]
    return nil if place['id'].nil?
    Place.new(place)
  end

  def self.fetch_location_score id
    url = "http://beermapping.com/webservice/locscore/#{key}/#{id}"
    response = HTTParty.get url
    location_score = response.parsed_response["bmp_locations"]["location"]
    return nil if location_score["overall"].nil?
    LocationScore.new(location_score)
  end

  def self.key
    Settings.beermapping_apikey
  end
end
