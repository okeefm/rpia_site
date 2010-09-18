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
  attr_accessible :name, :email, :username, :address

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true, 
                    :length => { :maximum => 50 }
  validates :address, :presence => true
  validates :email, :presence => true, 
                    :format => {:with => email_regex }
  validates :username, :presence => true,
                       :length => {:maximum => 25 },
                       :uniqueness => { :case_sensitive => false }
end
