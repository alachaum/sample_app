# == Schema Information
# Schema version: 20110123105842
#
# Table name: microposts
#
#  id          :integer         not null, primary key
#  content     :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  in_reply_to :integer
#

class Micropost < ActiveRecord::Base
  attr_accessible :content, :in_reply_to

  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validate :in_reply_to_id_exists, :in_reply_to_id_cannot_be_replier, 
            :if => "!in_reply_to.nil?"

  default_scope :order => 'microposts.created_at DESC'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  scope :including_replies, lambda { |user| microposts_or_replies(user) }
  scope :feed_for, lambda { |user| build_feed_for(user) }

  def reply?
    !in_reply_to.nil?
  end

  private
    
    def self.followed_by(user)
      @followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id) 
      where("user_id IN (#{@followed_ids}) OR user_id = :user_id", 
            {:user_id => user})
    end

    def self.build_feed_for(user)
      @followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id) 
      where("user_id IN (#{@followed_ids}) 
            OR user_id = :user_id 
            OR in_reply_to IN (#{@followed_ids})
            OR in_reply_to = :user_id", 
            {:user_id => user})
    end

    def self.microposts_or_replies(user)
      where("user_id = :user_id OR in_reply_to = :user_id",
            {:user_id => user})
    end

    def in_reply_to_id_exists
      if User.find_by_id(in_reply_to).nil?
        errors.add(:in_reply_to, "user does not exist")
      end
    end

    def in_reply_to_id_cannot_be_replier
      if in_reply_to == user.id
        errors.add(:in_reply_to, "user is the replier")
      end
    end
end
