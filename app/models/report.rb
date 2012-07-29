class Report < ActiveRecord::Base
  attr_accessible :report_type, :description, :location

  belongs_to :user
  has_many :votes


  def confirmation_count(params)
    Vote.where(:report_id => params[:id] ).where(:type => "confirm").count
  end
    
  def inaccuracy_count(params)
    Vote.where(:report_id => params[:id] ).where(:type => "inaccurate").count
  end 
  
  
  validates_numericality_of :latitude, :allow_nil => true,
    :greater_than_or_equal_to => -90.0,
    :less_than_or_equal_to    => 90.0
  validates_numericality_of :longitude, :allow_nil => true,
    :greater_than_or_equal_to => -180.0,
    :less_than_or_equal_to    => 180.0

  # protected_attributes = {created_at, updated_at, user_id, latest_status, co
  # confirmation_count = number of confirmations
  # inaccuracy_count = number of inaccurate votes
  # location = string
  # latitude = float
  # longitude = float
  # type = eg. traffic accident, shooting
  # description = optional

end
