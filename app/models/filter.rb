class Filter < ActiveRecord::Base
	has_and_belongs_to_many :pois
	belongs_to :category
	belongs_to :subcategory
end
