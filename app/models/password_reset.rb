# == Schema Information
# Schema version: 20110124131446
#
# Table name: password_resets
#
#  id         :integer         not null, primary key
#  token      :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  email      :string(255)
#

require 'digest'

class PasswordReset < ActiveRecord::Base
  attr_accessible :email
  
  belongs_to :user
  
  validates :email, :presence => true
  
  validate :user_email_exists
  
  before_create :relate_entry, :generate_token, :activate_unique_request
  
  private
    
    def user_email_exists
      if User.find_by_email(email).nil?
        errors.add(:email, "does not relate to any user")
      end
    end
    
    def relate_entry
      user = User.find_by_email(email)
      self.user_id = user.id
    end
    
    def generate_token
      user = User.find_by_email(email)
      self.token = secure_hash("#{Time.now.utc}--#{user.encrypted_password}")
    end
    
    def activate_unique_request      
      old_active_requests = PasswordReset.where(:active => true, :user_id => self.user_id)
      if !old_active_requests.empty?
        old_active_requests.each do |request|
          request.active = false
          request.save
        end
      end
      self.active = true
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
