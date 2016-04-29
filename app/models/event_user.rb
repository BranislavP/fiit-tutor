class EventUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates_uniqueness_of :user_id, :scope => :event_id
  validates :user_id, presence: true
  validates :event_id, presence: true
end
