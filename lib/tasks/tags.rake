namespace :tags do
  desc "Computation of tag relevance to category, subcategory and filters"
  task compute_relevances: :environment do
  	ConceptCategoryRelevance.delete_all
  	ConceptSubcategoryRelevance.delete_all
  	KeywordCategoryRelevance.delete_all
  	KeywordSubcategoryRelevance.delete_all
  	EntityCategoryRelevance.delete_all
  	EntitySubcategoryRelevance.delete_all


    # Relevance concept per category
    Concept.all.each do |concept|
      concept.poi_concepts.each do |poi_concept|
        poi_concept.poi.categories.each do |poi_category|
          concept_category_relevance = ConceptCategoryRelevance.find_or_create_by(:concept_id => concept.id, :category_id => poi_category.id)
          concept_category_relevance.relevance += poi_concept.relevance
          concept_category_relevance.occurrences += 1
          concept_category_relevance.save
        end
      end
    end

    # Relevance concept per subcategory
    Concept.all.each do |concept|
      concept.poi_concepts.each do |poi_concept|
        poi_concept.poi.subcategories.each do |poi_subcategory|
          concept_subcategory_relevance = ConceptSubcategoryRelevance.find_or_create_by(:concept_id => concept.id, :subcategory_id => poi_subcategory.id)
          concept_subcategory_relevance.relevance += poi_concept.relevance
          concept_subcategory_relevance.occurrences += 1
          concept_subcategory_relevance.save
        end
      end
    end

    # Relevance entity per category
    Entity.all.each do |entity|
      entity.poi_entities.each do |poi_entity|
        poi_entity.poi.categories.each do |poi_category|
          entity_category_relevance = EntityCategoryRelevance.find_or_create_by(:entity_id => entity.id, :category_id => poi_category.id)
          entity_category_relevance.relevance += poi_entity.relevance
          entity_category_relevance.occurrences += 1
          entity_category_relevance.save
        end
      end
    end

    # Relevance entity per subcategory
    Entity.all.each do |entity|
      entity.poi_entities.each do |poi_entity|
        poi_entity.poi.subcategories.each do |poi_subcategory|
          entity_subcategory_relevance = EntitySubcategoryRelevance.find_or_create_by(:entity_id => entity.id, :subcategory_id => poi_subcategory.id)
          entity_subcategory_relevance.relevance += poi_entity.relevance
          entity_subcategory_relevance.occurrences += 1
          entity_subcategory_relevance.save
        end
      end
    end

    # Relevance keyword per category
    Keyword.all.each do |keyword|
      keyword.poi_keywords.each do |poi_keyword|
        poi_keyword.poi.categories.each do |poi_category|
          keyword_category_relevance = KeywordCategoryRelevance.find_or_create_by(:keyword_id => keyword.id, :category_id => poi_category.id)
          keyword_category_relevance.relevance += poi_keyword.relevance
          keyword_category_relevance.occurrences += 1
          keyword_category_relevance.save
        end
      end
    end

    # Relevance keyword per subcategory
    Keyword.all.each do |keyword|
      keyword.poi_keywords.each do |poi_keyword|
        poi_keyword.poi.subcategories.each do |poi_subcategory|
          keyword_subcategory_relevance = KeywordSubcategoryRelevance.find_or_create_by(:keyword_id => keyword.id, :subcategory_id => poi_subcategory.id)
          keyword_subcategory_relevance.relevance += poi_keyword.relevance
          keyword_subcategory_relevance.occurrences += 1
          keyword_subcategory_relevance.save
        end
      end
    end

  end

end
