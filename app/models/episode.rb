require 'api_helper'

class Episode < ActiveRecord::Base

	belongs_to :show

	attr_accessible :show_id, :name, :airdate, :season_number, :episode_number

	validates :episode_number, uniqueness: { scope: [:show_id, :season_number] }
	validates :show_id, presence: true

	def numbers_and_name
		"S#{season_number}E#{episode_number} \"#{name}\""
	end

	def readable_name_and_airdate
		s = "#{numbers_and_name} ("
		date_diff = airdate - Time.current.in_time_zone("Pacific Time (US & Canada)").to_date
		if date_diff < 0
			s += "aired "
		else 
			s += "airing "
		end
		if date_diff > -7 and date_diff < 0
			s += "last" 
		elsif date_diff == 0
			s += "today,"
		elsif date_diff > 0 and date_diff < 7
			s += "this" 
		elsif date_diff >= 7 and date_diff < 14
			s += "next" 
		else
			s += "on"
		end
		s += " #{readable_airdate})"
		s
	end

	def readable_airdate
		"#{Date::DAYNAMES[airdate.wday]} #{airdate.to_s(:long_ordinal)}"
	end

	def self.build_from_quick_info(show, line)
		data = line.split('^')
		season_episode = data.first.split('x')
		season = season_episode[0].to_i
		episode = season_episode[1].to_i
		name = data[1]
		airdate = Date.parse(data[2])
		create(show_id: show.id, season_number: season, episode_number: episode, name: name, airdate: airdate)
	end

	def self.all_for_show(show)
		self.order("season_number desc, episode_number desc").find_by_show_id(show.id)
	end

	def self.pull_episodes(show, force = false)
		most_recent_in_db = self.limit(1).all_for_show(show)
		s_num = 1
		ep_num = 1
		if most_recent_in_db and !force
			s_num = most_recent_in_db.season_number
			ep_num = most_recent_in_db.episode_number
		end
		loop do
			params = { show: show.name, ep: "#{s_num}x#{ep_num}" }.to_param
			data = ApiHelper.fetch(params)
			info = data[ApiHelper::API_DATA_KEYS[:episode_info]]
			episode = build_from_quick_info(show, info) unless info.nil?
			show.episodes << episode unless episode.nil?
			if episode.nil?
				break if ep_num == 1
				ep_num = 1
				s_num += 1
				next
			elsif episode.airdate.future? 
				break
			end 
			ep_num += 1
		end

	end
end