class CreateVocabAssocMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :vocab_assoc_members do |t|
      t.references :vocab_assoc, foreign_key: true, null: false
      t.string :lemma, null: false
      t.string :comment

      t.timestamps
    end
    add_index :vocab_assoc_members, [:vocab_assoc_id, :lemma], unique: true
  end
end
