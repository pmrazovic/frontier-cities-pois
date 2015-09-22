class KeywordSubcategoryRelevance < ActiveRecord::Base
	belongs_to :keyword
	belongs_to :subcategory
end
