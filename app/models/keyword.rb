class Keyword < ActiveRecord::Base
	has_many :poi_keywords
	has_many :pois, :through => :poi_keywords
	has_many :keyword_category_relevances
	has_many :keyword_subcategory_relevances
end
