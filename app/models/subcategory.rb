class Subcategory < ActiveRecord::Base
	has_and_belongs_to_many :pois
	belongs_to :category
	has_many :filters
end
