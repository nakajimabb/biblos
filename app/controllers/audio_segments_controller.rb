class AudioSegmentsController < ApplicationController
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
end
