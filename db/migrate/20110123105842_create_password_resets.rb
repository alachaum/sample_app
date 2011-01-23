class CreatePasswordResets < ActiveRecord::Migration
  def self.up
    create_table :password_resets do |t|
      t.string :token
      t.integer :user_id

      t.timestamps
    end
    
    add_index :password_resets, :user_id
  end

  def self.down
    remove_index :password_resets, :user_id
    drop_table :password_resets
  end
end