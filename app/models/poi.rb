class Poi < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :subcategories
	has_and_belongs_to_many :filters
	belongs_to :neighborhood
end
