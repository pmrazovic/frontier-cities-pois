class CreateKeywordCategoryRelevances < ActiveRecord::Migration
  def change
    create_table :keyword_category_relevances do |t|
    	t.integer :keyword_id
    	t.integer :category_id
    	t.decimal :relevance, :default => 0.0
    	t.integer :occurrences, :default => 0
      t.timestamps
    end
  end
end
