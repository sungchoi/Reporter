require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:reports)
  should validate_presence_of(:username)
  should 'not allow a user with a short password' do
    u = User.new({
      :password => 'abcde',
      :password_confirmation => 'abcde'
    })
    assert !u.valid?
  end
end
