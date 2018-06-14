class CreateArticleUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :article_users do |t|
      t.references :article, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.integer :menu_type, null: false, limit: 1, default: 1
      t.integer :rank

      t.timestamps
    end
    add_index :article_users, [:article_id, :user_id, :menu_type], unique: true
  end
end
