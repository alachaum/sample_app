class AddColumnToPasswordReset < ActiveRecord::Migration
  def self.up
    add_column :password_resets, :active, :boolean, :default => false
  end

  def self.down
    remove_column :password_resets, :active
  end
end
