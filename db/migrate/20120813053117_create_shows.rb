class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.integer :quick_info_id

      t.timestamps
    end
  end
end
