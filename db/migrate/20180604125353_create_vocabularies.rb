class CreateVocabularies < ActiveRecord::Migration[5.2]
  def change
    create_table :vocabularies do |t|
      t.references :dictionary, foreign_key: true, null: false
      t.string :spell, null: false
      t.string :lemma, null: false
      t.text :meaning
      t.string :outline
      t.string :pronunciation
      t.string :transliteration
      t.string :etymology

      t.timestamps
    end
  end
end
