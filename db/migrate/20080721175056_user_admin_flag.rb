class UserAdminFlag < ActiveRecord::Migration
  def self.up
    add_column :accounts, :admin, :boolean
  end

  def self.down
    remove_column :accounts, :admin
  end
end
