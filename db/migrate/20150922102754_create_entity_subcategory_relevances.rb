class CreateEntitySubcategoryRelevances < ActiveRecord::Migration
  def change
    create_table :entity_subcategory_relevances do |t|
    	t.integer :entity_id
    	t.integer :subcategory_id
    	t.decimal :relevance, :default => 0.0
    	t.integer :occurrences, :default => 0
      t.timestamps
    end
  end
end
