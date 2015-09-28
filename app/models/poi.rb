class Poi < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :subcategories
	has_and_belongs_to_many :filters
	has_many :poi_concepts
	has_many :concepts, :through => :poi_concepts
	has_many :poi_keywords
	has_many :keywords, :through => :poi_keywords
	has_many :poi_entities
	has_many :entities, :through => :poi_entities
	belongs_to :neighborhood
	has_many :poi_category_relevances
end
