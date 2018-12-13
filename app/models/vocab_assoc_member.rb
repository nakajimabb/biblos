class VocabAssocMember < ApplicationRecord
  belongs_to :vocab_assoc

  validates :vocab_assoc_id, presence: true
  validates :lemma, presence: true
end
