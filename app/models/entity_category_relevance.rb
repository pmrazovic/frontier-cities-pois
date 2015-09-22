class EntityCategoryRelevance < ActiveRecord::Base
	belongs_to :entity
	belongs_to :category
end
