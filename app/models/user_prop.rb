class UserProp < ApplicationRecord
  belongs_to :user
  enum auth: {auth_user: 1, auth_public: 3} # auth_group: 2
  enum key: {auth_name: 0, first_name: 1, middle_name: 2, last_name: 3, first_name_kana: 4, middle_name_kana: 5, last_name_kana: 6,
             religion: 11, religious_sect: 12, church: 13, ministry: 14,
             zip1: 21, zip2: 22, prefecture: 23, city: 24, address1: 25, address2: 26, tel: 27, fax: 28,
             job: 31, work_place: 32 }
end
