class VocabCount < ApplicationRecord
  belongs_to :bible
  has_many :vocab_indices, :dependent => :destroy

  enum book_code: Canon::ENUM_BOOK
end
