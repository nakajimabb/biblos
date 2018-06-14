module ArticleHelper
  def target_article_path(article, target_group, target_user)
    if target_group
      group_article_path(article, group_id: target_group.id)
    elsif target_user
      user_article_path(article, user_id: target_user.id)
    else
      article_path(article)
    end
  end

  def target_articles_path(target_group, target_user)
    if target_group
      group_articles_path(group_id: target_group.id)
    elsif target_user
      user_articles_path(user_id: target_user.id)
    else
      articles_path
    end
  end
end
