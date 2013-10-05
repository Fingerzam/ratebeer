class PlacesController < ApplicationController
  def index
  end

  def search
    api_key = "9ff575cbe897a2650dfd81a6eb3e4a8b"
    url = "http://beermapping.com/webservice/loccity/#{api_key}/"
    response = HTTParty .get "#{url}#{params[:city].gsub(' ', '%20')}"
    places = response.parsed_response["bmp_locations"]["location"]

    if places.is_a?(Hash) and places['id'].nil?
      redirect_to places_path, notice: "No places in #{params[:city]}"
    else
      places = [places] if places.is_a?(Hash)
      @places = places.map {|place| Place.new(place) }
      render :index
    end
  end
end
