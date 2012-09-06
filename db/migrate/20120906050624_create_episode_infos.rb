class CreateEpisodeInfos < ActiveRecord::Migration
  def change
    create_table :episode_infos do |t|
			t.integer :quick_info_id
			t.string :name
			t.date :airdate

      t.timestamps
    end
  end
end
