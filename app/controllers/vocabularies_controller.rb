class VocabulariesController < ApplicationController
  before_action :set_vocabulary, only: [:update]

  def index
    @bread_crumb = [['聖書メニュー', nil], ['辞書検索', vocabularies_path]]
    if params.has_key?(:search)
      params[:search] = params[:search].strip
      vocabularies = Vocabulary.accessible(current_user.id)
      m = params[:search].match(/([GH])(\d+)/) # strong number
      if m
        lemma = sprintf('%s%04d', m[1], m[2].to_i)
        vocabularies = vocabularies.where(lemma: lemma)
      else
        vocabularies = vocabularies.where('spell like ? or meaning like ?', '%' + params[:search] + '%', '%' + params[:search] + '%')
      end
      if params[:lang].present?
        vocabularies = vocabularies.where(dictionaries: {lang: params[:lang]})
      end
      vocabularies = vocabularies.order('dictionaries.lang, spell').limit(100)
      @vocabularies = Hash.new{ |hash, key| hash[key] = [] }
      vocabularies.each do |vocabulary|
        if vocabulary.lemma
          @vocabularies[vocabulary.lemma] << vocabulary
        else
          @vocabularies[vocabulary.spell] << vocabulary
        end
      end
    end
  end

  def update
    @vocabulary.update!(vocabulary_params)

    redirect_back(fallback_location: root_path, notice: '更新しました')
  rescue => e
    redirect_back(fallback_location: root_path, alert: e.message)
  end

private
  def set_vocabulary
    @vocabulary = Vocabulary.find(params[:id])
  end

  def vocabulary_params
    params.require(:vocabulary).permit(:dictionary_id, :spell, :lemma, :meaning, :outline, :pronunciation, :transliteration, :etymology, :rank, images: [])
  end
end
