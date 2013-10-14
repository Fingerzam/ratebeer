class BeersController < ApplicationController
  before_filter :ensure_that_signed_in, :except => [:index, :show, :list]

  def expire_all
    expirables = ["beers-name", "beers-style", "beers-brewery"]
    expirables.each do |e|
      expire_fragment e, action: :index
    end
  end

  # GET /beers
  # GET /beers.json
  def index
    method_name = {'name' => :name, 'brewery' => :brewery, 'style' => :style}
    order_method = method_name[params[:order]] || :name
    @beers = Beer.all(include: [:brewery, :style]).sort_by(&order_method)
    @order = order_method.to_s

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @beers, methods: [:brewery, :style] }
    end
  end

  def list
  end

  # GET /beers/1
  # GET /beers/1.json
  def show
    @beer = Beer.find(params[:id])
    @rating = Rating.new
    @rating.beer = @beer

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @beer }
    end
  end

  # GET /beers/new
  # GET /beers/new.json
  def new
    @beer = Beer.new
    prepare_breweries_and_styles

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @beer }
    end
  end

  # GET /beers/1/edit
  def edit
    @beer = Beer.find(params[:id])
    prepare_breweries_and_styles
  end

  def prepare_breweries_and_styles
    @styles = Style.all
    @breweries = Brewery.all
  end

  # POST /beers
  # POST /beers.json
  def create
    @beer = Beer.new(params[:beer])

    expire_all

    respond_to do |format|
      if @beer.save
        format.html { redirect_to @beer, notice: 'Beer was successfully created.' }
        format.json { render json: @beer, status: :created, location: @beer }
      else
        format.html { render action: "new" }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /beers/1
  # PUT /beers/1.json
  def update
    @beer = Beer.find(params[:id])

    respond_to do |format|
      if @beer.update_attributes(params[:beer])
        expire_all
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    @beer = Beer.find(params[:id])
    @beer.destroy
    expire_all

    respond_to do |format|
      format.html { redirect_to beers_url }
      format.json { head :no_content }
    end
  end
end
