class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
			t.integer :show_id
			t.string :name
			t.date :airdate
			t.integer :season_number
			t.integer :episode_number

      t.timestamps
    end
  end
end
