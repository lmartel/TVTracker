class EpisodeInfo < ActiveRecord::Base

	belongs_to :quick_info

	attr_accessible :quick_info_id, :name, :airdate

end
