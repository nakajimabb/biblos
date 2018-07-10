class VocabulariesController < ApplicationController
  def index
    @bread_crumb = [['聖書メニュー', nil], ['辞書検索', vocabularies_path]]
    params[:search] = params[:search].strip
    if params[:search].present?
      vocabularies = Vocabulary.accessible(current_user.id)
      m = params[:search].match(/([GH])(\d+)/) # strong number
      if m
        lemma = m[1] + m[2].to_i.to_s
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
        if vocabulary.lemma.present?
          @vocabularies[vocabulary.lemma] << vocabulary
        else
          @vocabularies[vocabulary.spell] << vocabulary
        end
      end
    end
  end
end
