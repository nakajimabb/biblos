class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum member_type: {normal: 1, waiting: 2}
end
