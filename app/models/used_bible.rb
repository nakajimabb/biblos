class UsedBible < ApplicationRecord
  belongs_to :user
  belongs_to :bible
end
