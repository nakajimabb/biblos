class ChangeLemmaToVocabulariy < ActiveRecord::Migration[5.2]
  def up
    change_column :vocabularies, :lemma, :string, null: true
  end

  def down
    change_column :vocabularies, :lemma, :string, null: false
  end
end
