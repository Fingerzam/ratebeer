class RatingsController < ApplicationController
  before_filter :ensure_that_signed_in, :except => [:index]

  def index
    Rating
    Brewery
    Beer
    Style
    User
    @recent = Rails.cache.fetch(:recent_ratings, expires_in: 10.minutes) do
      Rating.last 5
    end
    @top_breweries = Rails.cache.fetch(:top_breweries, expires_in: 10.minutes) do
      Brewery.top 3
    end
    @top_beers = Rails.cache.fetch(:top_beers, expires_in: 10.minutes) do
      Beer.top 3
    end
    @top_styles = Rails.cache.fetch(:top_styles, expires_in: 10.minutes) do
      Style.top 3
    end
    @active_users = Rails.cache.fetch(:active_users, expires_in: 10.minutes) do
      User.active_users(3)
    end.select{|u| u != false and u != :@new_record}.take(3)
    @ratings_count = Rails.cache.fetch(:ratings_count, expires_in: 10.minutes) do
      Rating.count
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params[:rating]

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end
