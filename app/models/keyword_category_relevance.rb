class KeywordCategoryRelevance < ActiveRecord::Base
	belongs_to :keyword
	belongs_to :category
end
