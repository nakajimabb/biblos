class AddRankToVocabulary < ActiveRecord::Migration[5.2]
  def change
    add_column :vocabularies, :rank, :integer, null: false, default: 1, limit: 1
  end
end
