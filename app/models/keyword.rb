class Keyword < ActiveRecord::Base
	has_many :poi_keywords
	has_many :pois, :through => :poi_keywords
end
