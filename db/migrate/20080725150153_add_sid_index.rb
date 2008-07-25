class AddSidIndex < ActiveRecord::Migration
  def self.up
    add_index :nonces, :sid
  end

  def self.down
    remove_index :nonces, :sid
  end
end
