class RenameResolvedToAvailableInDoubts < ActiveRecord::Migration[8.0]
  def change
      rename_column :doubts, :resolved, :accepted
  end
end
