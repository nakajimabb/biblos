class VocabIndicesController < ApplicationController
  def scan
    @title = '単語カウント'
    @action = :scan_exec
    @enable_module_code = true
    render 'shared/simple_form'
  end

  def scan_exec
    @title = '単語カウント'
    @action = :scan_exec
    @enable_module_code = true
    bible =Bible.find_by(code: params[:module_code]) if params[:module_code].present?
    if bible.present?
      cannon_ot = Canon::BOOKS[:ot].map{ |item| [item[1], item[3]] }.to_h
      cannon_nt = Canon::BOOKS[:nt].map{ |item| [item[1], item[3]] }.to_h
      cannon = { 'WHNU' => cannon_nt, 'Byz' => cannon_nt, 'OSHB' => cannon_ot, 'LXX' => cannon_ot }
      create_vocab_indices(bible, cannon[bible.code])
    end
    render 'shared/simple_form'
  end

private

  def create_vocab_indices(bible, cannon)
    module_counts = {}
    cannon.each do |book_code, verse_counts|
      module_counts[book_code] = {}
      verse_counts.each_with_index do |verse_count, i|
        chapter = i + 1
        passages = bible.get_passages(book_code, chapter, 1, verse_count)
        passages.each do |verse, words|
          words.each do |word|
            lemma = word.lemma_code
            if lemma.present?
              module_counts[book_code][lemma] ||= []
              module_counts[book_code][lemma] << [chapter, verse]
            end
          end
        end
      end
    end
    module_counts.each do |book_code, book_counts|
      book_counts.each do |lemma, lemma_counts|
        vocab_count = VocabCount.find_or_create_by(bible_id: bible.id, book_code: book_code, lemma: lemma)
        vocab_count.update(count: lemma_counts.length)
        lemma_counts.each do |count|
          vocab_index = VocabIndex.find_or_create_by(vocab_count_id: vocab_count.id, chapter: count[0], verse: count[1])
          vocab_index.update(count: vocab_index.count+1)
        end
      end
    end
  end
end
