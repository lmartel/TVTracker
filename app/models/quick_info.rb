require 'net/http'

class QuickInfo < ActiveRecord::Base
	belongs_to :show
	has_many :episode_infos

	validates :api_id, uniqueness: true

	attr_accessible :show_id, :api_id, :name, :ended, :airtime

	before_create do |info|
		info.fetch
	end

	API_ENDPOINT = "http://services.tvrage.com/tools/quickinfo.php?"

	# is this generic enough to bother using an each?
	API_DATA_KEYS = { api_id: "Show ID", 
										name: "Show Name", 
										ended: "Ended", #need to convert from string to boolean
										airtime: "Airtime" #need to convert from string to datetime
									}

	def fetch
		if name.blank?
			self.errors.add(:name, "Name is blank")
			raise ActiveRecord::Rollback
		end
		params = { show: name }.to_param
		url = URI.parse(API_ENDPOINT + params)
		p url
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    # File.open("wikipage_testlog.txt", 'w') {|f| f.write(JSON.parse(res.body)) }
    load_data(parse_data(res.body))

	end

	def parse_data(result)
		data = Hash.new
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
		# this needs to be "Fridays at 8:30" not "THIS friday at 8:30"
		# probably just leave as string?
		self.airtime = DateTime.parse(data[API_DATA_KEYS[:airtime]])
	end
end
