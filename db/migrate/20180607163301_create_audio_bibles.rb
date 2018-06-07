class CreateAudioBibles < ActiveRecord::Migration[5.2]
  def change
    create_table :audio_bibles do |t|
      t.string :code, null: false
      t.string :name
      t.string :short_name
      t.integer :lang, limit: 1
      t.integer :record_type, null: false, default: 1, limit: 1
      t.text :remark
      t.integer :rank
      t.references :group, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :auth, null: false, default: 1, limit: 1
      t.boolean :hidden, null: false, default: false

      t.timestamps
    end
    add_index :audio_bibles, :code, unique: true
  end
end
