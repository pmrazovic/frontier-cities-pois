class CreateNeighborhoods < ActiveRecord::Migration
  def change
    create_table :neighborhoods do |t|
      t.string :name
      t.integer :district_id
      t.string :district_name

      t.timestamps
    end
  end
end
