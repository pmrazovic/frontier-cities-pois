class Subcategory < ActiveRecord::Base
	has_and_belongs_to_many :pois
	belongs_to :category
	has_many :filters
	has_many :concept_subcategory_relevances
	has_many :keyword_subcategory_relevances
	has_many :entity_subcategory_relevances
	has_many :poi_subcategory_relevances
end
