class MembershipsController < ApplicationController
  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @memberships }
    end
  end

  # GET /memberships/new
  # GET /memberships/new.json
  def new
    @membership = Membership.new
    @clubs = BeerClub.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @membership }
    end
  end

  # POST /memberships
  # POST /memberships.json
  def create
    ids = current_user.beer_clubs.map(&:id)
    unless ids.include? params[:membership][:beer_club_id].to_i
      membership = Membership.create params[:membership]
      current_user.memberships << membership
    end

    redirect_to :back
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to memberships_url }
      format.json { head :no_content }
    end
  end

  def confirm
    membership = Membership.find(params[:id])
    if membership.beer_club.confirmed_member?(current_user)
      membership.confirmed = true
      membership.save
    end
    redirect_to :back
  end
end
