class CreatePoiKeywords < ActiveRecord::Migration
  def change
    create_table :poi_keywords do |t|
    	t.integer :poi_id
    	t.integer :keyword_id
    	t.decimal :relevance
    	t.timestamps
    end
  end
end
