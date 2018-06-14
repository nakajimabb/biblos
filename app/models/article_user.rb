class ArticleUser < ApplicationRecord
  belongs_to :user
  belongs_to :article

  enum menu_type: {side_menu: 1, top_page: 2}
end
