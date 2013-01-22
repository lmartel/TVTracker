require 'net/http'

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
		show.load_data(show.fetch)
		# manually validate and add typos to aliases
		false unless show.valid?	
	end

	API_ENDPOINT = "http://services.tvrage.com/tools/quickinfo.php?"

	# is this generic enough to bother using an each?
	API_DATA_KEYS = { api_id: "Show ID", 
										name: "Show Name", 
										ended: "Ended",
										airtime: "Airtime",
										next_episode: "Next Episode"
									}

	def self.query(name)
		show = self.where(:name => name).first_or_create
	end

	def fetch
		if name.blank?
			self.errors.add(:name, "Name is blank")
			raise ActiveRecord::Rollback
		end
		params = { show: name }.to_param
		url = URI.parse(API_ENDPOINT + params)
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    # File.open("wikipage_testlog.txt", 'w') {|f| f.write(JSON.parse(res.body)) }
   	parse_data(res.body)
	end

	def parse_data(result)
		data = Hash.new
		# Removes html tags
		result = result.gsub(/<[^>]*>/, '')
		result.split("\n").each do |line|
			pair = line.split("@")
			data[pair[0]] = pair[1]
		end
		data
	end

	def load_data(data)
		self.api_id = data[API_DATA_KEYS[:api_id]].to_i
		self.name = data[API_DATA_KEYS[:name]]
		self.ended = data[API_DATA_KEYS[:ended]].present?
		self.airtime = data[API_DATA_KEYS[:airtime]]
		self.episodes << Episode.build_from_quick_info(data[API_DATA_KEYS[:next_episode]]) unless ended
	end
end
