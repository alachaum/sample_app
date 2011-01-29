class AddEmailToPasswordResets < ActiveRecord::Migration
  def self.up
    add_column :password_resets, :email, :string
  end

  def self.down
    remove_column :password_resets, :email
  end
end
