class AddEtcToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :nickname, :string, null: false, default: ''
    add_column :users, :code, :string
    add_column :users, :lang, :integer, limit: 1
    add_column :users, :sex, :integer, null: false, default: 1, limit: 1
    add_column :users, :birthday, :date
    add_index :users, :code, unique: true
  end
end
