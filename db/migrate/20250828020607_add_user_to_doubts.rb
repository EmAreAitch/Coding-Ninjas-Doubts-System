class AddUserToDoubts < ActiveRecord::Migration[8.0]
  def change
    add_reference :doubts, :user, null: false, foreign_key: true
  end
end
