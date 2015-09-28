class SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: [:show, :edit, :update, :destroy, :get_concepts, :get_entities, :get_keywords, :get_pois]

  # GET /subcategories
  # GET /subcategories.json
  def index
    @subcategories = Subcategory.all
  end

  # GET /subcategories/1
  # GET /subcategories/1.json
  def show
  end

  # GET /subcategories/new
  def new
    @subcategory = Subcategory.new
  end

  # GET /subcategories/1/edit
  def edit
  end

  # POST /subcategories
  # POST /subcategories.json
  def create
    @subcategory = Subcategory.new(subcategory_params)

    respond_to do |format|
      if @subcategory.save
        format.html { redirect_to @subcategory, notice: 'Subcategory was successfully created.' }
        format.json { render :show, status: :created, location: @subcategory }
      else
        format.html { render :new }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subcategories/1
  # PATCH/PUT /subcategories/1.json
  def update
    respond_to do |format|
      if @subcategory.update(subcategory_params)
        format.html { redirect_to @subcategory, notice: 'Subcategory was successfully updated.' }
        format.json { render :show, status: :ok, location: @subcategory }
      else
        format.html { render :edit }
        format.json { render json: @subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subcategories/1
  # DELETE /subcategories/1.json
  def destroy
    @subcategory.destroy
    respond_to do |format|
      format.html { redirect_to subcategories_url, notice: 'Subcategory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_concepts
    @concepts = ConceptSubcategoryRelevance.joins(:concept)
                                        .where(:subcategory => @subcategory).order('relevance DESC')
                                        .select("concepts.name as name, 
                                                 concept_subcategory_relevances.relevance as relevance, 
                                                 concept_subcategory_relevances.occurrences as occurrences")
  end

  def get_entities
    @entities = EntitySubcategoryRelevance.joins(:entity)
                                        .where(:subcategory => @subcategory).order('relevance DESC')
                                        .select("entities.name as name, 
                                                 entity_subcategory_relevances.relevance as relevance, 
                                                 entity_subcategory_relevances.occurrences as occurrences")
  end

  def get_keywords
    @keywords = KeywordSubcategoryRelevance.joins(:keyword)
                                        .where(:subcategory => @subcategory).order('relevance DESC')
                                        .select("keywords.text as text, 
                                                 keyword_subcategory_relevances.relevance as relevance, 
                                                 keyword_subcategory_relevances.occurrences as occurrences")
  end

  def get_pois
    @pois = PoiSubcategoryRelevance.joins(:poi)
                                   .where(:subcategory => @subcategory).order('normalized_relevance DESC')
                                   .select("pois.id,
                                            pois.title as title,
                                            pois.subtitle as subtitle,
                                            poi_subcategory_relevances.normalized_relevance as relevance")    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subcategory
      @subcategory = Subcategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subcategory_params
      params.require(:subcategory).permit(:name, :category_id)
    end
end
