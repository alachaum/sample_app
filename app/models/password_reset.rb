class PasswordReset < ActiveRecord::Base
  attr_accessor :email
  attr_accessible :email
  
  validate :user_email_exists
  
  before_save :relate_entry, :generate_token
  
  private
    
    def user_email_exists
      if User.find_by_email(email).nil?
        errors.add(:email, "user does not exist")
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
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
