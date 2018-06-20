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

  class Phrase
    attr_accessor :name, :text, :attributes, :parent, :children

    def initialize(name, text=nil, attributes=nil)
      @name = name
      @text = text
      @attributes = attributes
      @children = []
    end

    def empty?
      @text.blank? && @children.blank?
    end

    def attr_value(attr_name)
      str = attributes[attr_name]
      if str.present?
        i = str.rindex(':')
        if i
          str[(i+1)..-1]
        else
          str
        end
      end
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
    if bible_books.exists?(book_code: book_code)
      sword = Bible.get_sword_module(self.code)
      result = Hash.new{ |hash, key| hash[key] = [] }
      (verse1..verse2).each_with_index do |verse, i|
        raw_text = sword.raw_entry(book_code, chapter.to_i, verse)
        raw_text = raw_text.try(:force_encoding, 'utf-8')
        raw_text = Bible.strip_raw_entry(raw_text)
        if raw_text.present?
          raw_text = '<root>' + raw_text + '</root>'
          doc = REXML::Document.new(raw_text)
          root = doc.elements['root']
          result[verse] = Bible.parse_phrase(root)
        end
      end
      result
    end
  end

  def self.strip_raw_entry(text)
    i = text.index(/<CM>|<ZZ>|<\d+:/)
    if i.nil?
      text
    else
      text[0...i]
    end
  end

  def self.parse_phrase(element)
    phrase = Phrase.new(element.name.to_sym, element.texts.join.strip, element.attributes)
    children = []
    element.elements.each do |elem|
      children << parse_phrase(elem)
    end
    phrase.children = children
    phrase
  end

  def self.pick_notes(phrase)
    notes = []
    if phrase.name == :note
      if phrase.text.present?
        notes << phrase.dup
        phrase.name = :seg
        phrase.text = '*'
      end
    else
      phrase.children.each do |child|
        notes += pick_notes(child)
      end
    end
    notes
  end

  def self.merge_phrase(elements)
    if elements.present?
      Phrase.new(elements.first.name,
                 elements.map{ |e| e.text }.join.strip,
                 elements.map{ |e| e.attributes }.reduce({}){ |hash, attr| hash.merge(attr) })
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
