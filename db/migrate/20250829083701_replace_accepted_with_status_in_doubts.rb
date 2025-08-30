class ReplaceAcceptedWithStatusInDoubts < ActiveRecord::Migration[8.0]
  def change
    # Add the new integer column with default 0 (optional)
    add_column :doubts, :status, :integer, default: 0, null: false
  end
end
