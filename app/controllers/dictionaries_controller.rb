class DictionariesController < ApplicationController
  def get
    if params[:lemma].present?
      m = params[:lemma].match(/([GH])([0-9]+)/) if params[:lemma].present?

      if m.present?
        @lemma = m[1] + m[2].to_i.to_s
        @vocabularies = Vocabulary.where(lemma: @lemma)
        bible_ids = VocabCount.where(lemma: @lemma).group(:bible_id).pluck(:bible_id)
        @bibles = Bible.where(id: bible_ids)

        respond_to do |format|
          format.html do
            if params[:module_code].present? and params[:book_code].present?
              select_bible = Bible.find_by(code: params[:module_code])
              @vocab_count = VocabCount.find_by(bible_id: select_bible.id, book_code: params[:book_code], lemma: @lemma)
              @vocab_indices = @vocab_count.vocab_indices.page(params[:page]) if @vocab_count.present?
              used_bibles = current_user.valid_used_bibles.map { |used_bible| used_bible.bible }
              @bible_names = used_bibles.map { |bible| [bible.code, bible.name] }.to_h

              @passages = {}
              @vocab_indices.each do |vocab_index|
                passages = used_bibles.map { |bible| [bible.lang, {}] }.to_h
                used_bibles.each do |bible|
                  passages[bible.lang][bible.code] ||= {}
                  passages[bible.lang][bible.code] = bible.get_passages(params[:book_code], vocab_index.chapter, vocab_index.verse, vocab_index.verse)
                end
                @passages[vocab_index.id] = passages
              end
            end
            render :get
          end
          format.json do
            vocabulary = @vocabularies.first
            meaning = vocabulary.meaning
            meaning += "\n"
            @bibles.each do |bible|
              meaning += bible.code + '(' + VocabCount.where(bible_id: bible.id, lemma: @lemma).sum(:count).to_s + ') '
            end
            hash = {spell: vocabulary.spell, lemma: vocabulary.lemma, meaning: meaning,
                    pronunciation: vocabulary.pronunciation, transliteration: vocabulary.transliteration,
                    lang: vocabulary.dictionary.lang}
            render json: hash.try(:to_json)
          end
        end
      end
    end
  end

  def import_vocab
    @title = '辞書データ 読込'
    @action = :load_vocab
    @enable_file = true
    render 'shared/simple_form'
  end

  def load_vocab
    begin
      row_no = 0
      header = []
      file = params[:file].read
      CSV.parse(file) do |row|
        if row_no == 0
          header = row
        else
          params = {}
          dictionary = nil
          header.each_with_index do |col, i|
            val = row[i]
            case col.to_sym
              when :dictionary_code
                dictionary = Dictionary.find_by(code: val)
              else
                params[col.to_sym] = val.try(:force_encoding, 'utf-8')
            end
          end
          if dictionary.present?
            dictionary.vocabularies.create!(params)
          end
        end
        row_no += 1
      end
      redirect_to({:action => :import_vocab}, notice: 'successfully imported')
    rescue => e
      redirect_to({:action => :import_vocab}, alert: e.message)
    end
  end

end
