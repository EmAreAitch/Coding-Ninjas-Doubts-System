class AddResolvedToDoubts < ActiveRecord::Migration[8.0]
  def change
    add_column :doubts, :resolved, :boolean, default: false, null: false
  end
end
