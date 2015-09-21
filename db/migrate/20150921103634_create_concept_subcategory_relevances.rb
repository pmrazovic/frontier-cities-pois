class CreateConceptSubcategoryRelevances < ActiveRecord::Migration
  def change
    create_table :concept_subcategory_relevances do |t|
    	t.integer :concept_id
    	t.integer :subcategory_id
    	t.decimal :relevance
      t.timestamps
    end
  end
end
