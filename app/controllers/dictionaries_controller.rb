class DictionariesController < ApplicationController
  def get
    if params[:lemma].present?
      m = params[:lemma].match(/([GH])([0-9]+)/) if params[:lemma].present?

      if m.present?
        @lemma = m[1] + m[2].to_i.to_s
        @vocabularies = Vocabulary.where(lemma: @lemma)
        respond_to do |format|
          format.html { render :get }
          format.json do
            vocabulary = @vocabularies.first
            hash = {spell: vocabulary.spell, lemma: vocabulary.lemma, meaning: vocabulary.meaning,
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
