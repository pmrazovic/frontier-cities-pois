class ConceptCategoryRelevance < ActiveRecord::Base
	belongs_to :concept
	belongs_to :category
end
