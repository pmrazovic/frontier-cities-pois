class Concept < ActiveRecord::Base
	has_many :poi_concepts
	has_many :pois, :through => :poi_concepts
end
