class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :get_concepts, :get_entities, :get_keywords, :get_pois]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def get_concepts
    @concepts = ConceptCategoryRelevance.joins(:concept)
                                        .where(:category => @category).order('relevance DESC')
                                        .select("concepts.name as name, 
                                                 concept_category_relevances.relevance as relevance, 
                                                 concept_category_relevances.occurrences as occurrences")
  end

  def get_entities
    @entities = EntityCategoryRelevance.joins(:entity)
                                        .where(:category => @category).order('relevance DESC')
                                        .select("entities.name as name, 
                                                 entity_category_relevances.relevance as relevance, 
                                                 entity_category_relevances.occurrences as occurrences")
  end

  def get_keywords
    @keywords = KeywordCategoryRelevance.joins(:keyword)
                                        .where(:category => @category).order('relevance DESC')
                                        .select("keywords.text as text, 
                                                 keyword_category_relevances.relevance as relevance, 
                                                 keyword_category_relevances.occurrences as occurrences")
  end

  def get_pois
    @pois = PoiCategoryRelevance.joins(:poi)
                                .where(:category => @category).order('normalized_relevance DESC')
                                .select("pois.id,
                                         pois.title as title,
                                         pois.subtitle as subtitle,
                                         poi_category_relevances.normalized_relevance as relevance")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name)
    end
end
