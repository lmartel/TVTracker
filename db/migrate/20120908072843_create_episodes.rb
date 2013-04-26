class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
			t.integer :show_id
			t.string :name
			t.date :airdate
			t.integer :season_id
			t.integer :episode_id

      t.timestamps
    end
  end
end
