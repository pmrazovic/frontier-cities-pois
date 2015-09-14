class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      t.string :title
      t.string :subtitle
      t.integer :neighbourhood_id
      t.string :address
      t.string :telephone_number
      t.string :website_url
      t.string :longitude
      t.string :latitude
      t.string :transport
      t.string :working_hours
      t.string :prices
      t.text :description
      t.string :restaurant_prices
      t.string :hotel_categories
      t.string :festival_date
      t.text :data
      t.string :michelin_stars
      t.string :architect_name
      t.timestamps
    end
  end
end
