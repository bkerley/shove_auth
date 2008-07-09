class CreateNonces < ActiveRecord::Migration
  def self.up
    create_table :nonces do |t|
      t.string :nonce
      t.string :sid
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :nonces
  end
end
