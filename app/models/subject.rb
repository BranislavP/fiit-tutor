class Subject < ActiveRecord::Base
  has_many :events
  has_many :requests
end
