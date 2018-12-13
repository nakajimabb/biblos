class CreateVocabAssocs < ActiveRecord::Migration[5.2]
  def change
    create_table :vocab_assocs do |t|
      t.string :name, null: false
      t.integer :assoc_type, null: false, limit: 1

      t.timestamps
    end
  end
end
