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
  	categories = Category.where(:name => ['Museums', 'Architecture', 'Art', 'Leisure', 'Shopping'])
  	categories.each do |category|
  		
  		poi_concepts = PoiConcept.joins(:poi => :categories).where("categories.id = #{category.id}").uniq
  		poi_concepts.each do |poi_concept|
  			concept_category_relevance = ConceptCategoryRelevance.find_or_create_by(:concept_id => poi_concept.concept_id, :category_id => category.id)
				concept_category_relevance.relevance += poi_concept.relevance
				concept_category_relevance.occurrences += 1
				concept_category_relevance.save
  		end
  	end

  	# Relevance concept per subcategory
  	subcategories = Subcategory.joins(:category).where("categories.name IN ('Museums', 'Architecture', 'Art', 'Leisure', 'Shopping')")
  	subcategories.each do |subcategory|
  		
  		poi_concepts = PoiConcept.joins(:poi => :subcategories).where("subcategories.id = #{subcategory.id}").uniq
  		poi_concepts.each do |poi_concept|
  			concept_subcategory_relevance = ConceptSubcategoryRelevance.find_or_create_by(:concept_id => poi_concept.concept_id, :subcategory_id => subcategory.id)
				concept_subcategory_relevance.relevance += poi_concept.relevance
				concept_subcategory_relevance.occurrences += 1
				concept_subcategory_relevance.save
  		end
  	end

  	# Relevance keyword per category
  	categories = Category.where(:name => ['Museums', 'Architecture', 'Art', 'Leisure', 'Shopping'])
  	categories.each do |category|
  		
  		poi_keywords = PoiKeyword.joins(:poi => :categories).where("categories.id = #{category.id}").uniq
  		poi_keywords.each do |poi_keyword|
  			keyword_category_relevance = KeywordCategoryRelevance.find_or_create_by(:keyword_id => poi_keyword.keyword_id, :category_id => category.id)
				keyword_category_relevance.relevance += poi_keyword.relevance
				keyword_category_relevance.occurrences += 1
				keyword_category_relevance.save
  		end
  	end

  	# Relevance keyword per subcategory
  	subcategories = Subcategory.joins(:category).where("categories.name IN ('Museums', 'Architecture', 'Art', 'Leisure', 'Shopping')")
  	subcategories.each do |subcategory|
  		
  		poi_keywords = PoiKeyword.joins(:poi => :subcategories).where("subcategories.id = #{subcategory.id}").uniq
  		poi_keywords.each do |poi_keyword|
  			keyword_subcategory_relevance = KeywordSubcategoryRelevance.find_or_create_by(:keyword_id => poi_keyword.keyword_id, :subcategory_id => subcategory.id)
				keyword_subcategory_relevance.relevance += poi_keyword.relevance
				keyword_subcategory_relevance.occurrences += 1
				keyword_subcategory_relevance.save
  		end
  	end

  	# Relevance entity per category
  	categories = Category.where(:name => ['Museums', 'Architecture', 'Art', 'Leisure', 'Shopping'])
  	categories.each do |category|
  		
  		poi_entities = PoiEntity.joins(:poi => :categories).where("categories.id = #{category.id}").uniq
  		poi_entities.each do |poi_entity|
  			entity_category_relevance = EntityCategoryRelevance.find_or_create_by(:entity_id => poi_entity.entity_id, :category_id => category.id)
				entity_category_relevance.relevance += poi_entity.relevance
				entity_category_relevance.occurrences += 1
				entity_category_relevance.save
  		end
  	end

  	# Relevance entity per subcategory
  	subcategories = Subcategory.joins(:category).where("categories.name IN ('Museums', 'Architecture', 'Art', 'Leisure', 'Shopping')")
  	subcategories.each do |subcategory|
  		
  		poi_entities = PoiEntity.joins(:poi => :subcategories).where("subcategories.id = #{subcategory.id}").uniq
  		poi_entities.each do |poi_entity|
  			entity_subcategory_relevance = EntitySubcategoryRelevance.find_or_create_by(:entity_id => poi_entity.entity_id, :subcategory_id => subcategory.id)
				entity_subcategory_relevance.relevance += poi_entity.relevance
				entity_subcategory_relevance.occurrences += 1
				entity_subcategory_relevance.save
  		end
  	end


  end

end
