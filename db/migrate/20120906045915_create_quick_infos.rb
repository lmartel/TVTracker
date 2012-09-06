class CreateQuickInfos < ActiveRecord::Migration
  def change
    create_table :quick_infos do |t|
    	t.integer :show_id
    	t.integer :api_id
    	t.string :name
    	t.boolean :ended
    	t.datetime :airtime

      t.timestamps
    end
  end
end
