class LegacyFields < ActiveRecord::Migration
  def self.up
    #session[:token], session[:user], session[:company_id], session[:rights]
    adder = proc {|f, t| add_column :accounts, f, t}
    adder[:token, :string]
    adder[:company_id, :integer]
    adder[:first_name, :string]
    adder[:last_name, :string]
    adder[:legacy_admin, :boolean]
  end

  def self.down
    dropper = proc {|f| drop_column :accounts, f}
    dropper[:token, :string]
    dropper[:company_id, :integer]
    dropper[:first_name, :string]
    dropper[:last_name, :string]
    dropper[:legacy_admin, :boolean]
  end
end
