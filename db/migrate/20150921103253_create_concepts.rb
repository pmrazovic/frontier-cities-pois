class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
    	t.string :name
    	t.string :dbpedia_link
      t.timestamps
    end
  end
end
