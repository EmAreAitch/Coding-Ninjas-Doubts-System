class CreateDoubts < ActiveRecord::Migration[8.0]
  def change
    create_table :doubts do |t|
      t.string :title

      t.timestamps
    end
  end
end
