class CreateUserProps < ActiveRecord::Migration[5.2]
  def change
    create_table :user_props do |t|
      t.references :user, foreign_key: true, null: false
      t.integer :key, null: false, limit: 1
      t.string :value
      t.integer :auth, null: false, default: 1, limit: 1

      t.timestamps
    end
    add_index :user_props, [:user_id, :key], unique: true
  end
end
