class PoisFilters < ActiveRecord::Migration
  def change
  	create_table :pois_filters, id: false do |t|
      t.integer :poi_id
      t.integer :filter_id
    end
  end
end
