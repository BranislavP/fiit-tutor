class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  validates :content, presence: true
  validates :user_id, pressence: true
  validates :event_id, pressence: true
end
