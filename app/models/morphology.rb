class Morphology < ApplicationRecord
  belongs_to :group, optional: true
  belongs_to :user, optional: true
  has_many :morph_codes, :dependent => :destroy

  enum module_type: {sword: 1, db: 2}
  enum lang: {he: 1, grc: 2, ja: 3, en: 4, la: 5, ar: 6, fr: 7}
  enum auth: {auth_user: 1, auth_group: 2, auth_public: 3}


  def self.all(user_id=nil)
    if user_id.present?
      group_ids = GroupUser.where(user_id: user_id).pluck(:group_id)
      super().where(hidden: false).where('(auth = ?) or (auth = ? and user_id = ?) or (auth = ? and group_id in (?))',
                                         auths[:auth_public], auths[:auth_user], user_id, auths[:auth_group], group_ids)
    else
      super().where(hidden: false, auth: :auth_public)
    end
  end
end
