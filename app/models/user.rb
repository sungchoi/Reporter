class User < ActiveRecord::Base
  include UsersHelper

  attr_accessible :username, :email, :phone_number, :password,
    :password_confirmation
  has_secure_password

  has_many    :reports

  before_save :create_remember_token

  validates :username, :presence => true, :length => {maximum: 50}
  validates :password, :presence => true, :length => {:minimum => 6, :maximum => 20}
  validates :password_confirmation, :presence => true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
