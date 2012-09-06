class Wiki < ActiveRecord::Base
  has_many :wiki_pages
  has_many :shows, through: :wiki_pages

  validates :name, uniqueness: { case_sensitive: false }, allow_nil: true # :presence => true,
  # TODO: decide how vigorously to enforce uniqueness of wikis
  # validates :endpoint, uniqueness: true, presence: true
  before_validation :init

  # TODO: decide how extreme to be with initialization of blank attrs
  def init
    if endpoint.blank?
      self.endpoint = "http://en.wikipedia.org/w/api.php"
      if name.blank?
        self.name = "Wikipedia"
      end
    end
  end
end
