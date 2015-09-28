class CreatePoiCategoryRelevances < ActiveRecord::Migration
  def change
    create_table :poi_category_relevances do |t|
    	t.integer :poi_id
    	t.integer :category_id
    	t.decimal :total_relevance
    	t.decimal :concept_relevance
    	t.decimal :entity_relevance
    	t.decimal :keyword_relevance
      t.timestamps
    end
  end
end
