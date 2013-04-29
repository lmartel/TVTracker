class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create

  has_many :subscriptions
  has_many :shows, through: :subscriptions
  # has_many :episodes, through: subscriptions

  attr_accessible :email, :password, :password_confirmation
  validates :email, :uniqueness => :true
  
  def last_watched(show)
    sub = subscriptions.where(user_id: self.id, show_id: show.id)
    sub.episode unless sub.nil?
  end
end
