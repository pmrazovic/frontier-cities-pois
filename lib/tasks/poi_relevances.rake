namespace :poi_relevances do
  desc "Computing POI relevances to category"
  task compute: :environment do

  	PoiCategoryRelevance.delete_all
  	PoiSubcategoryRelevance.delete_all

  	pois = Poi.joins(:categories).where("categories.name in ('Museums','Architecture', 'Art', 'Leisure', 'Shopping')").uniq
    categories = Category.where(:name => ['Museums', 'Architecture', 'Art', 'Leisure', 'Shopping'])
  	
  	pois.each do |poi|
  		categories.each do |category|
  			concept_relevance_score = 0
  			poi.poi_concepts.each do |poi_concept|
          if poi_concept.concept.concept_category_relevances.where(:category_id => category.id).blank?
            concept_category_relevance = 0.0
          else
            concept_category_relevance = poi_concept.concept.concept_category_relevances.where(:category_id => category.id).first.relevance
          end
  				concept_relevance_score += concept_category_relevance * poi_concept.relevance
  			end
  			entity_relevance_score = 0
  			poi.poi_entities.each do |poi_entity|
          if poi_entity.entity.entity_category_relevances.where(:category_id => category.id).blank?
            entity_category_relevance = 0.0
          else
            entity_category_relevance = poi_entity.entity.entity_category_relevances.where(:category_id => category.id).first.relevance
          end
  				  entity_relevance_score += entity_category_relevance * poi_entity.relevance
  			end
  			keyword_relevance_score = 0
  			poi.poi_keywords.each do |poi_keyword|
          if poi_keyword.keyword.keyword_category_relevances.where(:category_id => category.id)
            keyword_category_relevance = 0.0
          else
            keyword_category_relevance = poi_keyword.keyword.keyword_category_relevances.where(:category_id => category.id).first.relevance
          end
  				keyword_relevance_score += keyword_category_relevance * poi_keyword.relevance
  			end
  			total_score = concept_relevance_score + entity_relevance_score + keyword_relevance_score

  			PoiCategoryRelevance.create(:poi_id => poi.id, :category_id => category.id,
  																	:sum_relevance => total_score,
  																	:concept_relevance => concept_relevance_score,
  																	:entity_relevance => entity_relevance_score,
  																	:keyword_relevance => keyword_relevance_score)

  		end
  	end

    subcategories = Subcategory.joins(:category).where("categories.name IN ('Museums', 'Architecture', 'Art', 'Leisure', 'Shopping')")
    
    pois.each do |poi|
      subcategories.each do |subcategory|
        concept_relevance_score = 0
        poi.poi_concepts.each do |poi_concept|
          if poi_concept.concept.concept_subcategory_relevances.where(:subcategory_id => subcategory.id).blank?
            concept_subcategory_relevance = 0.0
          else
            concept_subcategory_relevance = poi_concept.concept.concept_subcategory_relevances.where(:subcategory_id => subcategory.id).first.relevance
          end
          concept_relevance_score += concept_subcategory_relevance * poi_concept.relevance
        end
        entity_relevance_score = 0
        poi.poi_entities.each do |poi_entity|
          if poi_entity.entity.entity_subcategory_relevances.where(:subcategory_id => subcategory.id).blank?
            entity_subcategory_relevance = 0.0
          else
            entity_subcategory_relevance = poi_entity.entity.entity_subcategory_relevances.where(:subcategory_id => subcategory.id).first.relevance
          end
            entity_relevance_score += entity_subcategory_relevance * poi_entity.relevance
        end
        keyword_relevance_score = 0
        poi.poi_keywords.each do |poi_keyword|
          if poi_keyword.keyword.keyword_subcategory_relevances.where(:subcategory_id => subcategory.id)
            keyword_subcategory_relevance = 0.0
          else
            keyword_subcategory_relevance = poi_keyword.keyword.keyword_subcategory_relevances.where(:subcategory_id => subcategory.id).first.relevance
          end
          keyword_relevance_score += keyword_subcategory_relevance * poi_keyword.relevance
        end
        total_score = concept_relevance_score + entity_relevance_score + keyword_relevance_score

        PoiSubcategoryRelevance.create(:poi_id => poi.id, :subcategory_id => subcategory.id,
                                    :sum_relevance => total_score,
                                    :concept_relevance => concept_relevance_score,
                                    :entity_relevance => entity_relevance_score,
                                    :keyword_relevance => keyword_relevance_score)

      end
    end



  end

  desc "Normalizing POI relevances to category"
  task normalize: :environment do

    PoiCategoryRelevance.update_all(:total_relevance => 0.0, :normalized_relevance => 0.0)
    PoiSubcategoryRelevance.update_all(:total_relevance => 0.0, :normalized_relevance => 0.0)

    pois = Poi.joins(:categories).where("categories.name in ('Museums','Architecture', 'Art', 'Leisure', 'Shopping')").uniq
    categories = Category.where(:name => ['Museums', 'Architecture', 'Art', 'Leisure', 'Shopping'])
    subcategories = Subcategory.joins(:category).where("categories.name IN ('Museums', 'Architecture', 'Art', 'Leisure', 'Shopping')")
    maximum_sum_scores = PoiCategoryRelevance.where(:category_id => categories.pluck(:id)).group(:category_id).maximum(:sum_relevance)

    # adding extra relevance points if poi belongs to category
    pois.each do |poi|
      categories.each do |cat|
        if poi.categories.pluck(:id).include?(cat.id)
          PoiCategoryRelevance.where(:poi_id => poi.id, :category_id => cat.id).update_all("total_relevance = sum_relevance*1.3")
          if poi.top_20 == true
            PoiCategoryRelevance.where(:poi_id => poi.id, :category_id => cat.id).update_all("total_relevance = total_relevance + #{maximum_sum_scores[cat.id]*0.7}")
          end
        else
          PoiCategoryRelevance.where(:poi_id => poi.id, :category_id => cat.id).update_all("total_relevance = sum_relevance")
        end
      end
    end

    maximum_sum_scores = PoiCategoryRelevance.where(:category_id => categories.pluck(:id)).group(:category_id).maximum(:total_relevance)
    maximum_sum_scores.each do |category_id, max_score|
      PoiCategoryRelevance.where(:category_id => category_id).update_all("normalized_relevance = total_relevance/#{max_score}")
    end

    # adding extra relevance points if poi belongs to subcategory
    maximum_sum_scores = PoiSubcategoryRelevance.where(:subcategory_id => subcategories.pluck(:id)).group(:subcategory_id).maximum(:sum_relevance)
    pois.each do |poi|
      subcategories.each do |subcat|
        if poi.subcategories.pluck(:id).include?(subcat.id)
          PoiSubcategoryRelevance.where(:poi_id => poi.id, :subcategory_id => subcat.id).update_all("total_relevance = sum_relevance*1.3")
          if poi.top_20 == true
            PoiSubcategoryRelevance.where(:poi_id => poi.id, :subcategory_id => subcat.id).update_all("total_relevance = total_relevance + #{maximum_sum_scores[subcat.id]*0.7}")
          end
        else
          PoiSubcategoryRelevance.where(:poi_id => poi.id, :subcategory_id => subcat.id).update_all("total_relevance = sum_relevance")
        end
      end
    end

    maximum_sum_scores = PoiSubcategoryRelevance.where(:subcategory_id => subcategories.pluck(:id)).group(:subcategory_id).maximum(:total_relevance)
    maximum_sum_scores.each do |subcategory_id, max_score|
      PoiSubcategoryRelevance.where(:subcategory_id => subcategory_id).update_all("normalized_relevance = total_relevance/#{max_score}")
    end

  end


end














