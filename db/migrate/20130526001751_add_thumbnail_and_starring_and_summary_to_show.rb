require 'api_helper'

class AddThumbnailAndStarringAndSummaryToShow < ActiveRecord::Migration
  def up
    add_column :shows, :thumbnail, :string
    add_column :shows, :starring, :string
    add_column :shows, :summary, :text

    Show.all.each do |show|
      data = ApiHelper.fetch_supplementary(show.name)
      show.thumbnail = data[ApiHelper::API_DATA_KEYS[:thumbnail]]
      show.starring = data[ApiHelper::API_DATA_KEYS[:starring]]
      show.summary = data[ApiHelper::API_DATA_KEYS[:summary]]
      show.save
    end
  end

  def down
    remove_column :shows, :thumbnail
    remove_column :shows, :starring
    remove_column :shows, :summary
  end
end
