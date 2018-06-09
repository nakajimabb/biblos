class UsedLang < ApplicationRecord
  belongs_to :user
  enum lang: Lang::LANG
end
