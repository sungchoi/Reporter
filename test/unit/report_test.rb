require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  should belong_to(:user)
  should have_many(:votes)
  [-90.0, -33.3, -45.0, 0.0, 37.5, 45.0, 90.0].each do |lat|
    should_allow(lat).for(:latitude)
  end
end
