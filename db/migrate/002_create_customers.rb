class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.column :client_id, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :phone, :string
      t.column :email, :string
    end

    add_column :issues, :customer_id, :integer
  end

  def self.down
    drop_table :customers
    remove_column :issues, :customer_id
  end
end

