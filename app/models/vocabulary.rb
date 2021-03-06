class Vocabulary < ApplicationRecord
  belongs_to :dictionary
  has_many_attached :images

  def self.accessible(user_id=nil)
    dictionary_ids = Dictionary.accessible(user_id).pluck(:id)
    all.joins(:dictionary).where(dictionaries: {id: dictionary_ids})
  end
end
