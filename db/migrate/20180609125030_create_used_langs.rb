class CreateUsedLangs < ActiveRecord::Migration[5.2]
  def change
    create_table :used_langs do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :lang, limit: 1
    end
    add_index :used_langs, [:user_id, :lang], unique: true
  end
end
