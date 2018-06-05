class CreateMorphCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :morph_codes do |t|
      t.references :morphology, foreign_key: true, null: false
      t.string :parsing, null: false
      t.string :remark

      t.timestamps
    end
  end
end
