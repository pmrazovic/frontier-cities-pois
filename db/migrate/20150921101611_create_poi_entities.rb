class CreatePoiEntities < ActiveRecord::Migration
  def change
    create_table :poi_entities do |t|
    	t.integer :poi_id
    	t.integer :entity_id
    	t.decimal :relevance
    	t.timestamp
    end
  end
end
