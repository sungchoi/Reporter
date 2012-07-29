class Report < ActiveRecord::Base
  attr_accessible :report_type, :description, :location

  belongs_to :user
  has_many :votes

  # protected_attributes = {created_at, updated_at, user_id, latest_status, co
  # confirmation_count = number of confirmations
  # inaccuracy_count = number of inaccurate votes
  # location = string
  # latitude = float
  # longitude = float
  # type = eg. traffic accident, shooting
  # description = optional

end
