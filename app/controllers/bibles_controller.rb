class BiblesController < ApplicationController
  def index
    begin
      params[:chapter]  = 1 if params[:chapter].blank?
      params[:verse1]   = 1 if params[:verse1].blank?
      params[:verse2]   = 1 if params[:verse2].blank?
      params[:verse2] = params[:verse1] if params[:verse2].to_i < params[:verse1].to_i

      ot_books = Canon::BOOKS[:ot].map { |book| [book[0], book[1]] }
      nt_books = Canon::BOOKS[:nt].map { |book| [book[0], book[1]] }
      @books = ot_books + nt_books

      @bibles = {}
      Bible.all(current_user.id).each do |bible|
        @bibles[bible.lang] ||= []
        @bibles[bible.lang] << bible
      end

      if params[:book].present? and params[:chapter].present? and params[:verse1].present? and params[:verse2].present? and params[:modules].present?
        @passages = {}
        @chapter = params[:chapter].to_i
        @verse1 = params[:verse1].to_i
        @verse2 = params[:verse2].to_i
        @select_modules = {}
        Bible.all(current_user.id).where(code: params[:modules]).each do |bible|
          @select_modules[bible.code] = bible
          passages = bible.get_passages(params[:book], @chapter, @verse1, @verse2)
          if passages.present?
            @passages[bible.lang] ||= {}
            @passages[bible.lang][bible.code] = passages
          end
        end
        @audio_bibles = AudioBible.all(current_user.id).select{ |audio_bible| File.exist?(audio_bible.file_abs_path(params[:book], params[:chapter].to_i)) }
      end
    rescue => e
      flash[:alert] = e.message
    end
  end

  def sword
    @modules = Bible.load_sword_modules
  end

  def import_sword
    @title = 'import sword modules'
    @action = :import_sword_exec

    render 'shared/simple_form'
  end

  def import_sword_exec
    @title = 'import sword modules'
    @action = :import_sword_exec

    modules = Bible.load_sword_modules
    modules.each do |name, infos|
      bible = Bible.find_by(code: name)
      if bible.blank?
        bible = Bible.create(code: name, name: name, short_name: name, module_type: :sword, lang: infos['lang'], auth: :auth_public)
        bible.update(rank: bible.id)
      end
    end
    render 'shared/simple_form'
  end
end
