class PoiSubcategoryRelevance < ActiveRecord::Base
	belongs_to :poi
	belongs_to :subcategory
end
