class CreateVocabIndices < ActiveRecord::Migration[5.2]
  def change
    create_table :vocab_indices do |t|
      t.references :vocab_count, foreign_key: true, null: false
      t.integer :chapter, null: false, limit: 2
      t.integer :verse, null: false, limit: 2
      t.integer :count, null: false, default: 0, limit: 1

      t.timestamps
    end
    add_index :vocab_indices, [:vocab_count_id, :chapter, :verse], unique: true
  end
end
