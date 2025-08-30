class AddResolutionTimeToDoubts < ActiveRecord::Migration[8.0]
  def change
    add_column :doubts, :resolution_time, :integer
  end
end
