class AudioSegment < ApplicationRecord
  belongs_to :audio_bible

  enum book_code: Canon::ENUM_BOOK

  def self.accessible(user_id=nil)
    audio_bible_ids = AudioBible.accessible(user_id).pluck(:id)
    all.joins(:audio_bible).where(audio_bibles: {id: audio_bible_ids})
  end

  def next_position
    AudioSegment.find_by(audio_bible_id: audio_bible_id, book_code: book_code, chapter: chapter, verse: verse + 1).try(:position)
  end
end
