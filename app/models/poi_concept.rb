class PoiConcept < ActiveRecord::Base
	belongs_to :concept
	belongs_to :poi
end
