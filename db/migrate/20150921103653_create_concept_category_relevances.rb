class CreateConceptCategoryRelevances < ActiveRecord::Migration
  def change
    create_table :concept_category_relevances do |t|
    	t.integer :concept_id
    	t.integer :category_id
    	t.decimal :relevance, :default => 0.0
    	t.integer :occurrences, :default => 0
      t.timestamps
    end
  end
end
