class MorphCodesController < ApplicationController
  def get
    parsing = params[:parsing].strip.split.at(0)
    if parsing.present?
      @morph = MorphCode.where(parsing: parsing).order(:scheme).first

      if @morph.present?
        respond_to do |format|
          format.html { render :get }
          format.json do
            hash = { scheme: @morph.scheme, parsing: @morph.parsing, remark: @morph.remark }
            render json: hash.try(:to_json)
          end
        end
      end
    end
  end

  def import
    @title = 'morph データ 読込'
    @action = :load
    @enable_file = true
    render 'shared/simple_form'
  end

  def load
    begin
      row_no = 0
      header = []
      file = params[:file].read
      CSV.parse(file) do |row|
        if row_no == 0
          header = row
        else
          params = {}
          header.each_with_index do |col, i|
            val = row[i]
            params[col.to_sym] = val.try(:force_encoding, 'utf-8')
          end
          MorphCode.create!(params)
        end
        row_no += 1
      end
      redirect_to({:action => :import}, notice: 'successfully imported')
    rescue => e
      redirect_to({:action => :import}, alert: e.message)
    end
  end
end
