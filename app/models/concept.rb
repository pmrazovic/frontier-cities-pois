class Concept < ActiveRecord::Base
	has_many :poi_concepts
	has_many :pois, :through => :poi_concepts
	has_many :concept_category_relevances
end
