# == Schema Information
# Schema version: 20101220064126
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :microposts, :dependent => :destroy
  has_many :relationships, :foreign_key => "follower_id",
                            :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationship, :foreign_key => "followed_id",
                                  :class_name => "Relationship",
                                  :dependent => :destroy
  has_many :followers, :through => :reverse_relationship,
                        :source => :follower
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
                    :length => { :maximum => 50 }

  validates :email, :presence => true,
                    :format => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false }

  validates :password, :presence => true,
                       :confirmation => true,
                     :length => { :within => 6..40 }
  
  before_save :encrypt_password

  #Returns true if the user submits the right password
  def has_password?(submitted_password)
    self.encrypted_password == encrypt(submitted_password)
  end

  #Returns the user if ok, else nil
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    (user && user.has_password?(submitted_password)) ? user : nil
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
  end

  def feed
    Micropost.feed_for(self)
  end
  
  private
    
    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(self.password)
    end

    def encrypt(string)
      secure_hash("#{self.salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{self.password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
