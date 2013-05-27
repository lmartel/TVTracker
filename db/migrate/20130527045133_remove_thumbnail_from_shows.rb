class RemoveThumbnailFromShows < ActiveRecord::Migration
  def up
    remove_column :shows, :thumbnail
  end

  def down
    add_column :shows, :thumbnail, :string
  end
end
