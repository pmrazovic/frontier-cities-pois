class CreateConcepts < ActiveRecord::Migration
  def change
    create_table :concepts do |t|
    	t.string :name
    	t.string :dbpedia_link
    	t.string :yago_link
    	t.string :freebase_link
      t.timestamps
    end
  end
end
