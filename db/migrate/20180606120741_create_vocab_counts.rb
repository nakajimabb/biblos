class CreateVocabCounts < ActiveRecord::Migration[5.2]
  def change
    create_table :vocab_counts do |t|
      t.references :bible, foreign_key: true, null: false
      t.integer :book_code, null: false, limit: 2
      t.string :lemma
      t.integer :count, null: false, default: 0

      t.timestamps
    end
    add_index :vocab_counts, [:bible_id, :book_code, :lemma], unique: true
  end
end
