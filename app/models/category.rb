class Category < ActiveRecord::Base
	has_and_belongs_to_many :pois
	has_many :subcategories
	has_many :filters
	has_many :concept_category_relevances
	has_many :keyword_category_relevances
end
