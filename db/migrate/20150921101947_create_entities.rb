class CreateEntities < ActiveRecord::Migration
  def change
    create_table :entities do |t|
    	t.string :name
    	t.string :entity_type
      t.timestamps
    end
  end
end
