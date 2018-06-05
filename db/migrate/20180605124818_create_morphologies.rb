class CreateMorphologies < ActiveRecord::Migration[5.2]
  def change
    create_table :morphologies do |t|
      t.string :code, null: false
      t.string :name
      t.string :short_name
      t.integer :lang, limit: 1
      t.integer :module_type, null: false, default: 2, limit: 1
      t.integer :rank
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :auth, null: false, default: 1, limit: 1
      t.boolean :hidden, null: false, default: false

      t.timestamps
    end
    add_index :morphologies, :code, unique: true
  end
end
