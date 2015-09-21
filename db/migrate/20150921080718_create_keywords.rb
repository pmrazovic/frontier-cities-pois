class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
    	t.string :text
      t.timestamps
    end
  end
end
