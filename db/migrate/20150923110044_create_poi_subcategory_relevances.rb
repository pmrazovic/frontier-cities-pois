class CreatePoiSubcategoryRelevances < ActiveRecord::Migration
  def change
    create_table :poi_subcategory_relevances do |t|
    	t.integer :poi_id
    	t.integer :subcategory_id
    	t.decimal :total_relevance
    	t.decimal :concept_relevance
    	t.decimal :entity_relevance
    	t.decimal :keyword_relevance
      t.timestamps
      t.timestamps null: false
    end
  end
end
