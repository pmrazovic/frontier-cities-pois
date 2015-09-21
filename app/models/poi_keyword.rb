class PoiKeyword < ActiveRecord::Base
	belongs_to :keyword
	belongs_to :poi
end
