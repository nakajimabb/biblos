# require 'sword'


class BiblesController < ApplicationController
  def index
    begin
      params[:chapter]  = 1 if params[:chapter].blank?
      params[:verse1]   = 1 if params[:verse1].blank?
      params[:verse2]   = 1 if params[:verse2].blank?
      params[:verse2] = params[:verse1] if params[:verse2].to_i < params[:verse1].to_i
      if params[:modules].blank?
        params[:modules] = current_user.valid_used_bibles.map { |used_bible| used_bible.bible.code }
      end
      @used_langs = current_user.valid_used_langs.map { |used_lang| used_lang.lang }

      ot_books = Canon::BOOKS[:ot].map { |book| [book[0], book[1]] }
      nt_books = Canon::BOOKS[:nt].map { |book| [book[0], book[1]] }
      @books = ot_books + nt_books

      @bibles = {}
      Bible.accessible(current_user.id).each do |bible|
        @bibles[bible.lang] ||= []
        @bibles[bible.lang] << bible
      end
      @bread_crumb = [['聖書メニュー', nil], ['聖書閲覧', bibles_path]]

      if params[:book_code].present? and params[:chapter].present? and params[:verse1].present? and params[:verse2].present? and params[:modules].present?
        @passages = {}
        @chapter = params[:chapter].to_i
        @verse1 = params[:verse1].to_i
        @verse2 = params[:verse2].to_i
        @select_modules = {}
        Bible.accessible(current_user.id).where(code: params[:modules]).order(:rank).each do |bible|
          @select_modules[bible.code] = bible
          passages = bible.get_passages(params[:book_code], @chapter, @verse1, @verse2)
          if passages.present?
            @passages[bible.lang] ||= {}
            @passages[bible.lang][bible.code] = passages
          end
        end
        @audio_bibles = AudioBible.accessible(current_user.id).order(:rank).select{ |audio_bible| File.exist?(audio_bible.file_abs_path(params[:book_code], params[:chapter].to_i)) }
      end
    rescue => e
      flash[:alert] = e.message
    end
  end

  def size_info
    result = {}
    if params[:book_code].present?
      result[:max_chapter] = Bible::BIBLE_SIZE[params[:book_code]].try(:length)
      if params[:chapter].present?
        result[:max_verse] = Bible::BIBLE_SIZE[params[:book_code]][params[:chapter].to_i - 1]
      end
    end
    render json: result.to_json
  end

  def sword
    @modules = Bible.load_sword_modules
    @bread_crumb = [['聖書メニュー', nil], ['モジュール一覧', bibles_sword_path]]
  end

  def get_bibles
    result = BibleBook.where(book_code: params[:book_code]).joins(:bible).pluck('bibles.code')
    render json: result.to_json
  end

  def check_sword
    ot_books = Canon::BOOKS[:ot].map { |book| [book[0], book[1]] }
    nt_books = Canon::BOOKS[:nt].map { |book| [book[0], book[1]] }
    @books = ot_books + nt_books
    if params[:bible_id].present? && params[:ot_nt]
      @err_passages = []
      bible =Bible.find(params[:bible_id])
      cannon_ot = Canon::BOOKS[:ot].map{ |item| [item[1], item[3]] }.to_h
      cannon_nt = Canon::BOOKS[:nt].map{ |item| [item[1], item[3]] }.to_h
      cannon = params[:ot_nt] == 'ot' ? cannon_ot : cannon_nt

      cannon.each do |book_code, verse_counts|
        bible_book = BibleBook.find_or_initialize_by(bible_id: bible.id, book_code: book_code)
        verse_counts.each_with_index do |verse_count, i|
          chapter = i + 1
          raw_text = {}
          1.step(verse_count) do |verse|
            raw_text[verse] = bible.get_raw_entry(book_code, chapter, verse)
          end
          if raw_text.present?
            1.step(verse_count) do |verse|
              if raw_text[verse].present?
                bible_book.save! if bible_book.new_record?
              else
                @err_passages << [book_code, chapter, verse, 'empty']
              end
            end
          else
            @err_passages << [book_code, chapter, nil, 'empty']
          end
        end
      end
    end
  end

private

  # def import_sword
  #   @title = 'import sword modules'
  #   @action = :load_sword
  #
  #   render 'shared/simple_form'
  # end
  #
  # def load_sword
  #   @title = 'import sword modules'
  #   @action = :load_sword
  #
  #   modules = Bible.load_sword_modules
  #   modules.each do |name, infos|
  #     bible = Bible.find_by(code: name)
  #     if bible.blank?
  #       bible = Bible.create(code: name, name: name, short_name: name, module_type: :sword, lang: infos['lang'], auth: :auth_public)
  #       bible.update(rank: bible.id)
  #     end
  #     book_names = Sword::Sword.get_book_names(name)
  #     book_names.each do |book_code|
  #       if Canon::ENUM_BOOK.keys.include?(book_code.to_sym)
  #         unless bible.bible_books.exists?(book_code: book_code)
  #           bible.bible_books.create(book_code: book_code)
  #         end
  #       end
  #     end
  #   end
  #   render 'shared/simple_form'
  # end
end
