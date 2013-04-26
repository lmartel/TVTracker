require 'net/http'

module ApiHelper

  API_ENDPOINT = "http://services.tvrage.com/tools/quickinfo.php?"

  # is this generic enough to bother using an each?
  API_DATA_KEYS = { api_id: "Show ID", 
                    name: "Show Name", 
                    ended: "Ended",
                    airtime: "Airtime",
                    next_episode: "Next Episode",
                    episode_info: "Episode Info"
                  }
    
  def self.fetch(params)
    url = URI.parse(API_ENDPOINT + params)
    req = Net::HTTP::Get.new(url.request_uri)
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(req)
    end
    # File.open("wikipage_testlog.txt", 'w') {|f| f.write(JSON.parse(res.body)) }
    parse_data(res.body)
  end

  def self.parse_data(result)
    data = Hash.new
    # Removes html tags
    result = result.gsub(/<[^>]*>/, '')
    result.split("\n").each do |line|
      pair = line.split("@")
      data[pair[0]] = pair[1]
    end
    data
  end

end