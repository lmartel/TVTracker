require 'net/http'

class WikiPage < ActiveRecord::Base
	belongs_to :show
  belongs_to :wiki

  # validates :show_id, presence: true
  validates :wiki, presence: true

  before_create do |page|
    page.wiki ||= Wiki.find_or_create_by_name("Wikipedia")
  end
  # before_create do |wiki_page|
  #   wiki_page.build_wiki if wiki.blank?
  # end
  after_create :init
    def self.test
        title = "List of Community episodes"
        params = {
          :format => "json",
          :action => "query",
          #:titles => URI.escape(title).to_s,
          :prop => "revisions",
          :rvprop => "content"
        }
        params = params.to_param
        params += "&#{URI.escape(title)}"
        title = "Community_(season_1)"
        # URI.to_param is getting fucked up, and order might matter. Fuck the hash.
        #url = URI.parse("http://en.wikipedia.org/w/api.php?format=json&action=query&titles=#{URI.escape(title)}&prop=revisions&rvprop=content")
        # url = URI.parse("http://en.wikipedia.org/w/api.php?action=parse&page=List_of_Community_episodes")
        url = URI.parse("http://services.tvrage.com/tools/quickinfo.php?show=Community")
        req = Net::HTTP::Get.new(url.request_uri)
        res = Net::HTTP.start(url.host, url.port) do |http|
            http.request(req)
        end
        # File.open("wikipage_testlog.txt", 'w') {|f| f.write(JSON.parse(res.body)) }
        res.body

    end

    def init
        # create show first, import name, do a search, get id, then get title, then start parsing for episode stuff
        show.name
    end


    def loadPageID
    end

    def loadPageTitle
    end
end
# class WikiPage < ActiveResource::Base
#     self.site = "http://en.wikipedia.org/w/api.php"
# end