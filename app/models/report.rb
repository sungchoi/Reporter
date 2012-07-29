class Report < ActiveRecord::Base
  belongs_to :user
  has_many :votes
  attr_accessible :type, :description, :event_time, :event_location
  
  # protected_attributes = {created_at, updated_at, user_id, latest_status, confirmation_count, inaccuracy_count, latitude, longitude}
  # confirmation_count = number of confirmations
  # inaccuracy_count = number of inaccurate votes
  # location = string
  # latitude = float
  # longitude = float
  # type = eg. traffic accident, shooting
  # description = optional
  
  
  
end
