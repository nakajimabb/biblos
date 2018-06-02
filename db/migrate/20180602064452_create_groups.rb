class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :code, null: false
      t.string :name
      t.integer :group_type, null: false, default: 1, limit: 1
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :groups, :code, unique: true
  end
end
