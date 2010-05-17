class AddIpClients < ActiveRecord::Migration
  def self.up
    add_column :clients, :ip, :string
  end

  def self.down
    remove_column :clients, :ip
  end
end

