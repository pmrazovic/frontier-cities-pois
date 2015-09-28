class AddTop20ToPois < ActiveRecord::Migration
  def change
  	add_column :pois, :top_20, :boolean, :default => false
  end
end
