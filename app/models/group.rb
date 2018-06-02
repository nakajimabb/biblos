class Group < ApplicationRecord
  has_many :group_users, :dependent => :destroy
  has_many :users, :through => :group_users
  belongs_to :user, optional: true

  enum group_type: {auth: 1, community: 2}
end
