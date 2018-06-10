module BibleHelper
  def equal_lemma?(lemma1, lemma2)
    m1 = lemma1.match(/([GH])([0-9]+)/)
    m2 = lemma2.match(/([GH])([0-9]+)/)
    if m1.present? && m2.present?
      m1[1] == m2[1] && m1[2].to_i == m2[2].to_i
    end
  end
end
