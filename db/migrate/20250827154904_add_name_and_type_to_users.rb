class AddNameAndTypeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :type, :string, null: false
  end
end
