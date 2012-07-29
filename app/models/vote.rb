class Vote < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
end

class Confirm < Vote
  
end

class Inaccurate < Vote
  
end