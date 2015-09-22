class Entity < ActiveRecord::Base
	has_many :poi_entities
	has_many :pois, :through => :poi_entities
	has_many :entity_category_relevances
	has_many :entity_subcategory_relevances
end
