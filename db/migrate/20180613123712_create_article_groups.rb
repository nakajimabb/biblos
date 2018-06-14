class CreateArticleGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :article_groups do |t|
      t.references :article, foreign_key: true
      t.references :group, foreign_key: true
      t.integer :rank
      t.integer :menu_type

      t.timestamps
    end
    add_index :article_groups, [:article_id, :group_id, :menu_type], unique: true
  end
end
