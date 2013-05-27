require "open-uri"

class AddPosterToShow < ActiveRecord::Migration
  def up
    add_attachment :shows, :poster

    Show.all.each do |show|
      begin
        if show.thumbnail
          show.poster = open(show.thumbnail) 
          show.save
        end
      rescue Exception => e
        # Do nothing (poster is "N/A")
      end
    end
  end

  def down
    remove_attachment :shows, :poster
  end
end
