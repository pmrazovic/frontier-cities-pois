namespace :tags do
  desc "Computation of tag relevance to category, subcategory and filters"
  task compute_relevances: :environment do
  	ConceptCategoryRelevance.delete_all
  	ConceptSubcategoryRelevance.delete_all

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


  		rels = ConceptSubcategoryRelevance.where(:subcategory_id => subcategory.id).order('relevance desc')
  		puts "------------------------------------------>>>>>>>>>>>>>"
  		puts subcategory.name
  		rels.each do |rel|
  			puts "#{rel.concept.name} ---> #{rel.relevance} (#{rel.occurrences})"
  		end

  	end



  end

end
