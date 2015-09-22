class CreateKeywordSubcategoryRelevances < ActiveRecord::Migration
  def change
    create_table :keyword_subcategory_relevances do |t|
    	t.integer :keyword_id
    	t.integer :subcategory_id
    	t.decimal :relevance, :default => 0.0
    	t.integer :occurrences, :default => 0
      t.timestamps
    end
  end
end
