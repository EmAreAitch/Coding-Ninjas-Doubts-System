class AddNameToTaStats < ActiveRecord::Migration[8.0]
  def change
    add_column :ta_stats, :name, :string, null: false
  end
end
