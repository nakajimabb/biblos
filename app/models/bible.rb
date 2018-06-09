require 'sword'


class Bible < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :user, optional: true
  enum module_type: {sword: 1}
  enum lang: {he: 1, grc: 2, ja: 3, en: 4, la: 5, ar: 6, fr: 7}
  enum auth: {auth_user: 1, auth_group: 2, auth_public: 3}

  @@sword = {}

  BIBLE_SIZE = (Canon::BOOKS[:ot].map { |book| [book[1], book[3]] }.to_h).merge(Canon::BOOKS[:nt].map { |book| [book[1], book[3]] }.to_h)

  Word = Struct.new(:text, :lemma, :morph) do
    def lemma_code
      /([G,H])(\d+)/.match(self.lemma) ? $1 + $2.to_i.to_s : ''
    end
  end

  def self.accessible(user_id=nil)
    if user_id.present?
      group_ids = GroupUser.where(user_id: user_id).pluck(:group_id)
      all.where(hidden: false).where('(auth = ?) or (auth = ? and user_id = ?) or (auth = ? and group_id in (?))',
                                          auths[:auth_public], auths[:auth_user], user_id, auths[:auth_group], group_ids)
    else
      all.where(hidden: false, auth: :auth_public)
    end
  end

  def get_passages(book_code, chapter, verse1, verse2)
    sword = Bible.get_sword_module(self.code)
    words = sword.get_texts(book_code, chapter.to_i, verse1.to_i, verse2.to_i)
    result = {}
    (verse1..verse2).each_with_index do |verse, i|
      passage = words[i].map do |word|
        text = word['Text'].try(:force_encoding, 'utf-8')
        lemma = word['Lemma'].try(:force_encoding, 'utf-8')
        morph = word['Morph'].try(:force_encoding, 'utf-8')
        text.present? ? Word.new(text, lemma, morph) : nil
      end
      passage.compact!
      result[verse] = passage if passage.present?
    end
    result
  end

  def self.load_sword_modules
    modules = {}
    Sword::Sword.get_module_infos.each_with_index do |m, i|
      code = m['name'].try(:force_encoding, 'utf-8')
      modules[code] = {}
      m.each do |k, v|
        key = k.try(:force_encoding, 'utf-8')
        value = v.try(:force_encoding, 'utf-8')
        modules[code][key] = value
      end
    end
    modules
  end

private

  def Bible.get_sword_module(code)
    @@sword[code] ||= Sword::Sword.new(code)
  end
end
