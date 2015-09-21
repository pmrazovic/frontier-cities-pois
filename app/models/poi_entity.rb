class PoiEntity < ActiveRecord::Base
	belongs_to :entity
	belongs_to :poi
end
