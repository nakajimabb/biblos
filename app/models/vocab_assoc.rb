class VocabAssoc < ApplicationRecord
  has_many :vocab_assoc_members, :dependent => :destroy

  enum assoc_type: {derivative: 1, synonym: 2, related: 3, translated: 6}
  validates :name, presence: true
  validates :assoc_type, presence: true
end
