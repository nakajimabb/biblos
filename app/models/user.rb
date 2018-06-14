class User < ApplicationRecord
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable, :timeoutable  #, :confirmable, :omniauthable

  has_many :group_users, :dependent => :destroy
  has_many :groups, :through => :group_users
  has_many :user_props, :dependent => :destroy
  accepts_nested_attributes_for :user_props, allow_destroy: true
  has_many :used_langs, :dependent => :destroy
  has_many :used_bibles, :dependent => :destroy
  has_many :articles, :dependent => :destroy
  has_many :article_users, :dependent => :destroy

  enum lang: Lang::LANG
  enum sex: {male: 1, female: 2}

  validates :nickname, presence: true


  def valid_used_bibles
    used_bibles = self.used_bibles
    if used_bibles.present?
      used_bibles
    else
      default_user = User.find_by(code: :ja)
      default_user.present? ? default_user.used_bibles : UsedBible.none
    end
  end

  def valid_used_langs
    used_langs = self.used_langs
    if used_langs.present?
      used_langs
    else
      default_user = User.find_by(code: :ja)
      default_user.present? ? default_user.used_langs : UsedLang.none
    end
  end

  def headline(omission='...')
    headline = article_users.where(menu_type: :top_page).first.try(:article).try(:headline)
    headline + omission if headline.present?
  end
end
