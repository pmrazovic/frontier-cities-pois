class PoisSubcategories < ActiveRecord::Migration
  def change
  	create_table :pois_subcategories, id: false do |t|
      t.integer :poi_id
      t.integer :subcategory_id
    end
  end
end
