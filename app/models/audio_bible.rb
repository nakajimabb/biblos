class AudioBible < ApplicationRecord
  has_many :audio_segments, :dependent => :destroy

  enum book_code: Canon::ENUM_BOOK
  enum record_type: {mp3: 1, m4a: 2}
  enum lang: {he: 1, grc: 2, ja: 3, en: 4, la: 5, ar: 6, fr: 7}
  enum auth: {auth_user: 1, auth_group: 2, auth_public: 3}

  def self.all(user_id=nil)
    if user_id.present?
      group_ids = GroupUser.where(user_id: user_id).pluck(:group_id)
      super().where(hidden: false).where('(auth = ?) or (auth = ? and user_id = ?) or (auth = ? and group_id in (?))',
                                         auths[:auth_public], auths[:auth_user], user_id, auths[:auth_group], group_ids)
    else
      super().where(hidden: false, auth: :auth_public)
    end
  end

  def file_abs_path(book_code, chapter)
    Rails.root.to_s + '/public' + self.file_path(book_code, chapter)
  end

  def file_path(book_code, chapter)
    '/audio/' + self.code + '/' + book_code.to_s + '/' + sprintf('%04d', chapter.to_i) + '.' + self.record_type.to_s
  end
end
