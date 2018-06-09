class CreateUsedBibles < ActiveRecord::Migration[5.2]
  def change
    create_table :used_bibles do |t|
      t.references :user, foreign_key: true, null: false
      t.references :bible, foreign_key: true, null: false
    end
    add_index :used_bibles, [:user_id, :bible_id], unique: true
  end
end
