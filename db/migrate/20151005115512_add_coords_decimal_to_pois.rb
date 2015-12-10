class AddCoordsDecimalToPois < ActiveRecord::Migration
  def change
  	add_column :pois, :latitude_decimal, :decimal
  	add_column :pois, :longitude_decimal, :decimal
  end
end
