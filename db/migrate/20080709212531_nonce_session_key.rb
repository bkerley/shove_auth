class NonceSessionKey < ActiveRecord::Migration
  def self.up
    add_column :nonces, :session_secret, :string
  end

  def self.down
    drop_column :nonces, :session_secret
  end
end
