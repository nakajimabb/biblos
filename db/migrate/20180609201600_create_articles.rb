class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.references :user, foreign_key: true, null: false
      t.references :group, foreign_key: true
      t.references :parent
      t.boolean :directory, null: false, default: false
      t.string :title, null: false
      t.string :headline, limit: 512
      t.text :remark
      t.integer :auth, null: false, limit: 1, default: 1
      t.boolean :permit_comment, null: false, default: true

      t.timestamps
    end
    add_foreign_key :articles, :articles, column: :parent_id
  end
end
