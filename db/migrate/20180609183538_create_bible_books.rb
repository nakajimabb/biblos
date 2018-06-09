class CreateBibleBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :bible_books do |t|
      t.references :bible, foreign_key: true, null: false
      t.integer :book_code, null: false, limit: 2
      t.string :book_name
    end
    add_index :bible_books, [:bible_id, :book_code], unique: true
  end
end
