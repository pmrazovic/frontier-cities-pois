class PoiCategoryRelevance < ActiveRecord::Base
	belongs_to :poi
	belongs_to :category
end
