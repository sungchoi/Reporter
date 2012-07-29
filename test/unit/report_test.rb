require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  should belong_to(:user)
  should have_many(:votes)
  should 'allow valid latitudes' do
    [-90.0, -33.3, -45.0, 0.0, 37.5, 45.0, 90.0].each do |lat|
      r = Report.new
      r.latitude = lat
      assert r.valid?
    end
  end
end
