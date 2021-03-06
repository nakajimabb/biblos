module BibleHelper
  def equal_lemma?(lemma1, lemma2)
    m1 = lemma1.match(/([GH])([0-9]+)/)
    m2 = lemma2.match(/([GH])([0-9]+)/)
    if m1.present? && m2.present?
      m1[1] == m2[1] && m1[2].to_i == m2[2].to_i
    end
  end

  def phrase_class_text(phrase)
    'phrase-' + phrase.name.to_s
  end

  def phrase_attr_text(phrase)
    phrase.attributes.map{ |key, attr| "data-#{key}=" + attr.to_s }.join(' ')
  end
end
