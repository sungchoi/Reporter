class Report < ActiveRecord::Base
  attr_accessible :report_type, :description, :location, :latitude, :longitude,
    :image_url, :live_stream

  belongs_to :user
  has_many :confirms
  has_many :inaccurates

  def confirmation_count
    confirms.count
  end

  def inaccuracy_count
    inaccurates.count
  end

  def to_hash
    {
      :id                 => id,
      :report_type        => report_type,
      :description        => description,
      :location           => location,
      :latitude           => latitude,
      :longitude          => longitude,
      :image_url          => image_url,
      :live_stream        => live_stream,
      :confirmation_count => confirmation_count,
      :inaccuracy_count   => inaccuracy_count,
      :created_at         => created_at,
      :updated_at         => updated_at
    }
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
