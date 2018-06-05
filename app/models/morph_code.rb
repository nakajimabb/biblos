class MorphCode < ApplicationRecord
  belongs_to :morphology

  def self.all(user_id=nil)
    morphology_ids = Morphology.all(user_id).pluck(:id)
    super().joins(:morphology).where(morphologies: {id: morphology_ids})
  end
end
