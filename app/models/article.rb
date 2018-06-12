class Article < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true
  belongs_to :parent, class_name: 'Article', foreign_key: :parent_id, optional: true
  has_many :children, class_name: 'Article', foreign_key: :parent_id

  enum auth: {auth_user: 1, auth_group: 2, auth_public: 3}

  validates :title, presence: true

  HEADLINE_BYTESIZE = 512

  def self.accessible(user_id=nil)
    if user_id.present?
      group_ids = GroupUser.where(user_id: user_id).pluck(:group_id)
      all.where('(auth = ?) or (auth = ? and user_id = ?) or (auth = ? and group_id in (?))',
                                     auths[:auth_public], auths[:auth_user], user_id, auths[:auth_group], group_ids)
    else
      all.where(auth: :auth_public)
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
end