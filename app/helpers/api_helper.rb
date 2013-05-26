require 'net/http'
require 'json'

module ApiHelper

  SHOW_API_ENDPOINT = "http://services.tvrage.com/tools/quickinfo.php?"
  THUMBNAIL_API_ENDPOINT = "http://www.omdbapi.com/?"

  # is this generic enough to bother using an each?
  API_DATA_KEYS = { api_id: "Show ID", 
                    name: "Show Name", 
                    ended: "Ended",
                    airtime: "Airtime",
                    next_episode: "Next Episode",
                    episode_info: "Episode Info",

                    thumbnail: "Poster",
                    starring: "Actors",
                    summary: "Plot"
                  }
    
  def self.fetch(params)
    uri = URI.parse(SHOW_API_ENDPOINT + params)
    result = get_request(uri)
    data = parse_data(result)
    data[API_DATA_KEYS[:name]] = data[API_DATA_KEYS[:name]].gsub(/\ \([0-9]+\)/, "") # Remove the "(year)" from the title string, if present
    data.merge!(self.fetch_supplementary(data[API_DATA_KEYS[:name]]))
    data
  end

  def self.parse_data(result)
    data = Hash.new

    # Removes html tags
    result.gsub!(/<[^>]*>/, '')

    # UTF8-ify weird unicode characters
    result.force_encoding('UTF-8')
    result.split("\n").each do |line|
      pair = line.split("@")
      data[pair[0]] = pair[1]
    end
    data
  end

  def self.fetch_supplementary(name)
    data = {}
    params = {t: name}.to_param
    uri = URI.parse(THUMBNAIL_API_ENDPOINT + params)
    result = JSON.parse(get_request(uri))
    if(result["Response"] == "False")
      data[API_DATA_KEYS[:thumbnail]] = "http://placehold.it/118x170"
      data[API_DATA_KEYS[:starring]] = "Unknown"
      data[API_DATA_KEYS[:summary]] = "Unknown"
    else
      data[API_DATA_KEYS[:thumbnail]] = result[API_DATA_KEYS[:thumbnail]]
      data[API_DATA_KEYS[:starring]] = result[API_DATA_KEYS[:starring]]
      data[API_DATA_KEYS[:summary]] = result[API_DATA_KEYS[:summary]]
    end
    data
  end

  def self.get_request(uri)
    req = Net::HTTP::Get.new(uri.request_uri)
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      http.request(req)
    end
    res.body
  end

end