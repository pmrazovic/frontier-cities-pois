class AddSumRelevance < ActiveRecord::Migration
  def change
  	add_column :poi_category_relevances, :sum_relevance, :decimal, :default => 0.0
  	add_column :poi_subcategory_relevances, :sum_relevance, :decimal, :default => 0.0
  end
end
