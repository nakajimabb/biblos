class Group < ApplicationRecord
  has_many :group_users, :dependent => :destroy
  has_many :users, :through => :group_users
  belongs_to :user, optional: true
  has_many :articles, :dependent => :destroy
  has_many :article_groups, :dependent => :destroy

  enum group_type: {auth: 1, community: 2}

  def headline(omission='...')
    headline = article_groups.where(menu_type: :top_page).first.try(:article).try(:headline)
    headline + omission if headline.present?
  end
end
