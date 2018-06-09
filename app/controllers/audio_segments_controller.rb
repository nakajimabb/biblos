class AudioSegmentsController < ApplicationController
  def edit
    ot_books = Canon::BOOKS[:ot].map { |book| [book[0], book[1]] }
    nt_books = Canon::BOOKS[:nt].map { |book| [book[0], book[1]] }
    @books = ot_books + nt_books

    @audio_bible = AudioBible.find(params[:audio_bible_id]) if params[:audio_bible_id].present?
    if @audio_bible.present? && params[:book_code].present? && params[:chapter].present?
      @audio_file = @audio_bible.file_path(params[:book_code], params[:chapter])
      @audio_file_path = @audio_bible.file_abs_path(params[:book_code], params[:chapter])
      @audio_segments = AudioSegment.where(audio_bible_id: params[:audio_bible_id], book_code: params[:book_code], chapter: params[:chapter]).order(:verse)
    end
  end

  def regist
    audio_bible = AudioBible.find(params[:audio_bible_id]) if params[:audio_bible_id].present?
    if audio_bible.present?
      verse = audio_bible.audio_segments.maximum(:verse)
      audio_bible.audio_segments.create(book_code: params[:book_code], chapter: params[:chapter], verse: verse.to_i + 1, position: params[:position])
      update_audio_segment_order(audio_bible.audio_segments.where(book_code: params[:book_code], chapter: params[:chapter]))
    end

    redirect_to action: :edit, audio_bible_id: params[:audio_bible_id], book_code: params[:book_code], chapter: params[:chapter], position: params[:position]
  end

  def destroy
    audio_segment = AudioSegment.find(params[:id])
    if audio_segment.present?
      audio_bible = audio_segment.audio_bible
      audio_segments = audio_bible.audio_segments.where(book_code: audio_segment.book_code, chapter: audio_segment.chapter)
      audio_segment.destroy
      update_audio_segment_order(audio_segments)
    end
    redirect_back(fallback_location: root_path, notice: 'successfully destroyed')
  end

  def import
    @title = '朗読データ 読込'
    @action = :load
    @enable_file = true
    render 'shared/simple_form'
  end

  def load
    begin
      row_no = 0
      header = []
      file = params[:file].read
      audio_modules = {}
      CSV.parse(file) do |row|
        if row_no == 0
          header = row
        else
          params = {}
          audio_module = nil
          header.each_with_index do |col, i|
            val = row[i]
            key = col.to_sym
            case key
              when :audio_bible_code
                audio_modules[val] ||= AudioBible.find_by(code: val)
                audio_module = audio_modules[val]
                params[:audio_bible_id] = audio_module.id
              else
                params[key] = val
            end
          end
          audio_module.audio_segments.create(params) if audio_module.present?
        end
        row_no += 1
      end
      redirect_to({:action => :import}, notice: 'successfully imported')
    rescue => e
      redirect_to({:action => :import}, alert: e.message)
    end
  end

private
  def update_audio_segment_order(audio_segments)
    audio_segments.order(:position).each_with_index do |audio_segment, i|
      audio_segment.update(verse: i+1)
    end
  end
end
