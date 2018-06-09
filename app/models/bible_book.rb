class BibleBook < ApplicationRecord
  belongs_to :bible
  enum book_code: Canon::ENUM_BOOK
end
