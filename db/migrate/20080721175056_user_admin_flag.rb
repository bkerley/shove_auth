class UserAdminFlag < ActiveRecord::Migration
  def self.up
    add_column :accounts, :admin, :boolean
  end

  def self.down
    drop_column :accounts, :admin
  end
end
