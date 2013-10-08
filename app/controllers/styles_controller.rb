class StylesController < ApplicationController
  before_filter :admin?, only: [:destroy]
  before_filter :ensure_that_signed_in, except: [:index, :show]

  def index
    @styles = Style.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @styles }
    end
  end

  def show
    @style = Style.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @style }
    end
  end

  def edit
    @style = Style.find(params[:id])
  end

  def update
    @style = Style.find(params[:id])

    if @style.update_attributes(params[:style])
      redirect_to @style, notice: 'Style was updated successfully.'
    else
      render action: 'edit'
    end
  end

  def create
    @style = Style.new(params[:style])
    if @style.save
      redirect_to @style, notice: 'Style was created successfully.'
    else
      render action: "new"
    end
  end

  def new
    @style = Style.new
  end

  def destroy
    @style = Style.find(params[:id])
    @style.destroy
    redirect_to styles_url
  end
end
