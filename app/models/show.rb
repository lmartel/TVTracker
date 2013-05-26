require 'api_helper'

class Show < ActiveRecord::Base
  has_many :episodes, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :users, through: :subscriptions

	validates :api_id, uniqueness: true
	validates :name, presence: true

	# add cached aliases for typos etc?
	attr_accessible :show_id, :api_id, :name, :ended, :airtime, :thumbnail, :starring, :summary

	# putting this in a before_create rather than a before_validation skips validation. figure out how to avoid this.
	before_create do |show|
		show.fetch_and_load_data
		# manually validate and add typos to aliases
		false unless show.valid?	
	end

	# forces sort-descending on episodes
	alias_method :original_episodes, :episodes
	def episodes
		original_episodes.order("airdate asc")
	end

	def last_episode
		episodes.last
	end

	def next_episode(episode)
		if episode.nil?
			next_episode = episodes.first
		else
			next_episode = episodes.where(season_number: episode.season_number, episode_number: episode.episode_number + 1).first
			next_episode = episodes.where(season_number: episode.season_number + 1, episode_number: 1).first if next_episode.nil?
		end
		next_episode
	end

	def prev_episode(episode)
		if(episode.nil?)
			nil
		elsif episode.episode_number > 1
			episodes.where(season_number: episode.season_number, episode_number: episode.episode_number - 1).first
		elsif episode.season_number > 1
			episodes.find_all_by_season_number(episode.season_number - 1).last
		else
			nil
		end
	end


	def self.query(name)
		show = self.where(:name => name).first_or_create
	end

	def fetch_and_load_data
		if name.blank?
			self.errors.add(:name, "Name is blank")
			raise ActiveRecord::Rollback
		end
		params = { show: name }.to_param
		data = ApiHelper.fetch(params)
		self.api_id = data[ApiHelper::API_DATA_KEYS[:api_id]].to_i
		self.name = data[ApiHelper::API_DATA_KEYS[:name]]
		self.ended = data[ApiHelper::API_DATA_KEYS[:ended]].present?
		self.airtime = data[ApiHelper::API_DATA_KEYS[:airtime]]
		self.thumbnail = data[ApiHelper::API_DATA_KEYS[:thumbnail]]
		self.starring = data[ApiHelper::API_DATA_KEYS[:starring]]
		self.summary = data[ApiHelper::API_DATA_KEYS[:summary]]
	end

end
