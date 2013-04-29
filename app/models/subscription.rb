class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :show
  belongs_to :episode

  attr_accessible :user_id, :show_id, :episode_id

  validates :user_id, presence: true
  validates :show_id, presence: true, uniqueness: { scope: :user_id }
end