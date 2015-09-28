class EntitySubcategoryRelevance < ActiveRecord::Base
	belongs_to :entity
	belongs_to :subcategory
end
