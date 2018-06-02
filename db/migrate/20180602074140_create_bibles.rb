class CreateBibles < ActiveRecord::Migration[5.2]
  def change
    create_table :bibles do |t|
      t.string :code, null: false
      t.string :name
      t.string :short_name
      t.integer :lang, limit: 1
      t.integer :module_type, null: false, default: 1, limit: 1
      t.integer :rank
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :auth, null: false, default: 1, limit: 1

      t.timestamps
    end
    add_index :bibles, :code, unique: true
  end
end
