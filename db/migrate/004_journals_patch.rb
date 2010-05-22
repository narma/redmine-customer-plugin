class JournalsPatch < ActiveRecord::Migration
  def self.up
    add_column :journals, :client_visible, :integer
  end

  def self.down
    remove_column :journals, :client_visible
  end
end

