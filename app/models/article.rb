class Article < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true
  belongs_to :parent, class_name: 'Article', foreign_key: :parent_id, optional: true
  has_many :children, class_name: 'Article', foreign_key: :parent_id
  has_many :article_users, :dependent => :destroy
  has_many :article_groups, :dependent => :destroy

  enum auth: {auth_user: 1, auth_group: 2, auth_public: 3, auth_all: 4}

  validates :title, presence: true

  HEADLINE_BYTESIZE = 512

  def self.accessible(user_id=nil)
    if user_id.present?
      group_ids = GroupUser.where(user_id: user_id).pluck(:group_id)
      all.where('(auth >= ?) or (user_id = ?) or (auth = ? and group_id in (?))',
                                     auths[:auth_public], user_id, auths[:auth_group], group_ids)
    else
      all.where(auth: :auth_all)
    end
  end

  def parents(reverse = true)
    p_list = []
    p = self.parent
    while p
      p_list << p
      p = p.parent
    end
    p_list.reverse! if reverse
    p_list
  end

  def author_name(detail=false)
    if detail
      [group.try(:name), user.try(:nickname)].compact.join('／')
    else
      [group.try(:name), user.try(:nickname)].compact.first
    end
  end
end
