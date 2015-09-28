class AddNormalizedRelevanceToRelevances < ActiveRecord::Migration
  def change
  	add_column :poi_category_relevances, :normalized_relevance, :decimal
  	add_column :poi_subcategory_relevances, :normalized_relevance, :decimal
  end
end
