class CreateAudioSegments < ActiveRecord::Migration[5.2]
  def change
    create_table :audio_segments do |t|
      t.references :audio_bible, foreign_key: true
      t.integer :book_code, null: false, limit: 2
      t.integer :chapter, null: false, limit: 2
      t.integer :verse, null: false, limit: 2
      t.float :position, null: false

      t.timestamps
    end
  end
end
