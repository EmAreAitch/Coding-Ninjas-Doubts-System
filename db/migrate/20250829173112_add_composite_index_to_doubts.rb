class AddCompositeIndexToDoubts < ActiveRecord::Migration[8.0]
  def change
    add_index :doubts, [:created_at, :id], order: { created_at: :desc, id: :desc }, name: 'index_doubts_on_created_at_and_id_desc'
  end
end
