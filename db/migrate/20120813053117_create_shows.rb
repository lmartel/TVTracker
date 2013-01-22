class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
    	t.integer :api_id
    	t.string :name
    	t.boolean :ended
    	t.string :airtime

      t.timestamps
    end
  end
end
