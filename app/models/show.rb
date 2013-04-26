require 'api_helper'

class Show < ActiveRecord::Base
  has_many :episodes

  # This gets most recent episode
  # TODO: store past- and future- episodes separately? sorta need next and last
  # could also just compare current date/time to airdate/time
  # Episode.where(airdate: Episode.maximum("airdate"))

	validates :api_id, uniqueness: true
	validates :name, presence: true

	# add cached aliases for typos etc?
	attr_accessible :show_id, :api_id, :name, :ended, :airtime

	# putting this in a before_create rather than a before_validation skips validation. figure out how to avoid this.
	before_create do |show|
		show.fetch_and_load_data
		# manually validate and add typos to aliases
		false unless show.valid?	
	end

	# forces sort-descending on episodes
	alias_method :original_episodes, :episodes
	def episodes
		original_episodes.order("airdate desc")
	end

	def next_episode
		episodes.first
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
		# self.episodes << Episode.build_from_quick_info(data[API_DATA_KEYS[:next_episode]]) unless ended
		# Episode.pull_episodes(self)
	end
end
