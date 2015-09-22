class CreateEntityCategoryRelevances < ActiveRecord::Migration
  def change
    create_table :entity_category_relevances do |t|
    	t.integer :entity_id
    	t.integer :category_id
    	t.decimal :relevance, :default => 0.0
    	t.integer :occurrences, :default => 0
      t.timestamps
    end
  end
end
