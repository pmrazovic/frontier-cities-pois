class Category < ActiveRecord::Base
	has_and_belongs_to_many :pois
	has_many :subcategories
	has_many :filters
end
