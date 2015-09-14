class FiltersPois < ActiveRecord::Migration
  def change
  	create_table :filters_pois, id: false do |t|
      t.integer :poi_id
      t.integer :filter_id
    end
  end
end
