class CategoriesPois < ActiveRecord::Migration
  def change
  	create_table :categories_pois, id: false do |t|
      t.integer :poi_id
      t.integer :category_id
    end
  end
end
