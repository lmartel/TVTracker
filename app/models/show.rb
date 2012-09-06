class Show < ActiveRecord::Base
    has_one :quick_info

    validates :quick_info, uniqueness: true


    attr_accessible :quick_info_id
    # before_create do |show|
    #     show.create_wiki_page(:show_id => show.id) if wiki_page.blank?
    # end

	def testWikiGem
	end
end
