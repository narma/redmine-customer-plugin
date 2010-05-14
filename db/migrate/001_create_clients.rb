# Use rake db:migrate_plugins to migrate installed plugins
class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.column :name, :string
      t.column :address, :text
      t.column :phone, :string
      t.column :email, :string
      t.column :website, :string
    end

    add_column :clients, :project_id, :integer
    add_column :issues, :client_id, :integer
  end

  def self.down
    drop_table :clients
    remove_column :clients, :project_id
    remove_column :issues, :client_id
  end
end

