class ConceptSubcategoryRelevance < ActiveRecord::Base
	belongs_to :concept
	belongs_to :subcategory
end
