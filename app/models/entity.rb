class Entity < ActiveRecord::Base
	has_many :poi_entities
	has_many :pois, :through => :poi_entities
end
