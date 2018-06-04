class CreateMorphCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :morph_codes do |t|
      t.string :scheme
      t.string :parsing
      t.string :remark

      t.timestamps
    end
  end
end
