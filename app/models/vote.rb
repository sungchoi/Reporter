class Vote < ActiveRecord::Base

  attr_accessible :user_id, :report_id

  belongs_to :report
  belongs_to :user

end
