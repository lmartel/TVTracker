class AddShowIdIndexToEpisodes < ActiveRecord::Migration
  def change
    add_index :episodes, :show_id
  end
end
