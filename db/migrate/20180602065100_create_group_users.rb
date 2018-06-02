class CreateGroupUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :group_users do |t|
      t.references :group, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :member_type, null: false, default: 1, limit: 1

      t.timestamps
    end
    add_index :group_users, [:group_id, :user_id], unique: true
  end
end
