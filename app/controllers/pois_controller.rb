require 'alchemyapi'

class PoisController < ApplicationController
  before_action :set_poi, only: [:show, :edit, :update, :destroy, :get_poi_keywords, :get_poi_entities, :get_poi_concepts, :get_poi_text_categorization, :get_poi_taxonomy]

  # GET /pois
  # GET /pois.json
  def index
    @pois = Poi.all.paginate(:page => params[:page], :per_page => 30)
  end

  # GET /pois/1
  # GET /pois/1.json
  def show
  end

  # GET /pois/new
  def new
    @poi = Poi.new
  end

  # GET /pois/1/edit
  def edit
  end

  # POST /pois
  # POST /pois.json
  def create
    @poi = Poi.new(poi_params)

    respond_to do |format|
      if @poi.save
        format.html { redirect_to @poi, notice: 'Poi was successfully created.' }
        format.json { render :show, status: :created, location: @poi }
      else
        format.html { render :new }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pois/1
  # PATCH/PUT /pois/1.json
  def update
    respond_to do |format|
      if @poi.update(poi_params)
        format.html { redirect_to @poi, notice: 'Poi was successfully updated.' }
        format.json { render :show, status: :ok, location: @poi }
      else
        format.html { render :edit }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pois/1
  # DELETE /pois/1.json
  def destroy
    @poi.destroy
    respond_to do |format|
      format.html { redirect_to pois_url, notice: 'Poi was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_poi_keywords
    alchemyapi = AlchemyAPI.new()
    @response = alchemyapi.keywords('text', @poi.description, { 'sentiment'=>1 })
  end

  def get_poi_entities
    alchemyapi = AlchemyAPI.new()
    @response = alchemyapi.entities('text', @poi.description, { 'sentiment'=>1 })
  end

  def get_poi_concepts
    alchemyapi = AlchemyAPI.new()
    @response = alchemyapi.concepts('text', @poi.description)
  end

  def get_poi_text_categorization
    alchemyapi = AlchemyAPI.new()
    @response = alchemyapi.category('text', @poi.description)
  end

  def get_poi_taxonomy
    alchemyapi = AlchemyAPI.new()
    @response = alchemyapi.taxonomy('text', @poi.description)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_poi
      @poi = Poi.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def poi_params
      params.require(:poi).permit(:title, :subtitle, :neighborhood_id, :address, :telephone_number, :website_url, :longitude, :latitude, :transport, :working_hours, :prices, :description, :restaurant_prices, :hotel_categories, :festival_date, :data, :michelin_stars, :architect_name)
    end
end
