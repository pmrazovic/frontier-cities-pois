class CreatePoiConcepts < ActiveRecord::Migration
  def change
    create_table :poi_concepts do |t|
    	t.integer :poi_id
    	t.integer :concept_id
    	t.decimal :relevance
    end
  end
end
