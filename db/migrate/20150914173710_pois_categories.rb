class PoisCategories < ActiveRecord::Migration
  def change
  	create_table :pois_categories, id: false do |t|
      t.integer :poi_id
      t.integer :category_id
    end
  end
end
