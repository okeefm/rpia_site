# == Schema Information
# Schema version: 20100917044021
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  username   :string(255)
#  password   :string(255)
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :username, :address, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true, 
                    :length => { :maximum => 50 }
  validates :address, :presence => true
  validates :email, :presence => true, 
                    :format => {:with => email_regex }
  validates :username, :presence => true,
                       :length => {:maximum => 25 },
                       :uniqueness => { :case_sensitive => false }
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    #compare encrypted & submitted passwords
  end

  private

  def encrypt_password
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt(str)
    str #only temporary!
  end
end
