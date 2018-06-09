class MorphCode < ApplicationRecord
  belongs_to :morphology

  def self.accessible(user_id=nil)
    morphology_ids = Morphology.accessible(user_id).pluck(:id)
    all.joins(:morphology).where(morphologies: {id: morphology_ids})
  end
end
