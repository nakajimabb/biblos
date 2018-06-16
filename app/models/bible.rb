require 'rexml/document'
require 'sword'


class Bible < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :user, optional: true
  has_many :bible_books, :dependent => :destroy

  enum module_type: {sword: 1}
  enum lang: Lang::LANG
  enum auth: {auth_user: 1, auth_group: 2, auth_public: 3}

  @@sword = {}

  BIBLE_SIZE = (Canon::BOOKS[:ot].map { |book| [book[1], book[3]] }.to_h).merge(Canon::BOOKS[:nt].map { |book| [book[1], book[3]] }.to_h)

  Phrase = Struct.new(:name, :text, :lemma, :morph) do
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

  def lemma_or_morph(str)
    if str.present?
      i = str.rindex(':')
      if i
        str[(i+1)..-1]
      else
        str
      end
    end
  end

  def get_passages(book_code, chapter, verse1, verse2)
    if bible_books.exists?(book_code: book_code)
      sword = Bible.get_sword_module(self.code)
      result = Hash.new{ |hash, key| hash[key] = [] }
      (verse1..verse2).each_with_index do |verse, i|
        raw_text = sword.raw_entry(book_code, chapter.to_i, verse)
        raw_text = raw_text.try(:force_encoding, 'utf-8')
        if raw_text.present?
          raw_text = '<root>' + raw_text + '</root>'
          doc = REXML::Document.new(raw_text)
          root = doc.elements['root']
          if root.text.present?
            result[verse] << Phrase.new(:phrase_text, root.text, nil, nil)
          end
          root.elements.each do |elem|
            if elem.name == 'w'
              text = ''
              lemma = lemma_or_morph(elem.attributes['lemma'])
              morph = lemma_or_morph(elem.attributes['morph'])
              text += elem.text if elem.text.present?
              elem.elements.each('seg') do |seg|
                text += seg.text if seg.text.present?
              end
              result[verse] << Phrase.new(:phrase_word, text.strip, lemma, morph)
            elsif elem.name == 'seg'
              result[verse] << Phrase.new(:phrase_seg, elem.text, nil, nil) if elem.text.present?
            end
          end
        end
      end
      result
    end
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
