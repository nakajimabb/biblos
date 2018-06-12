class ArticlesController < ApplicationController
  def index
    @parent = Article.find_by_id(params[:parent_id])
    @articles = Article.accessible(current_user.id).where(parent_id: @parent.try(:id))
    @bread_crumb = get_bread_curmb(@parent)
  end

  def show
    @article = Article.accessible(current_user.id).find(params[:id])
    if @article.directory?
      redirect_to articles_path(parent_id: @article.id)
    end
    @bread_crumb = get_bread_curmb(@article.parent)
  end

  def new
    @parent = Article.find_by_id(params[:parent_id])
    @article = Article.new(parent_id: @parent.try(:id), directory: params[:directory] == 'true')
    @bread_crumb = get_bread_curmb(@parent)
    @bread_crumb << [@article.directory? ? 'カテゴリ追加' : '記事作成', nil]
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    @article.headline = get_headline(@article.remark)
    begin
      Article.transaction do
        @article.save!
      end
      redirect_to @article, notice: '記事を投稿しました。'
    rescue => e
      @bread_crumb = get_bread_curmb(@article.parent)
      @bread_crumb << [@article.directory? ? 'カテゴリ追加' : '記事作成', nil]
      flash[:notice] = e.message
      render :new
    end
  end

  def edit
    @article = Article.accessible(current_user.id).find(params[:id])
    @bread_crumb = get_bread_curmb(@article.parent)
    @bread_crumb << [@article.directory? ? 'カテゴリ編集' : '記事編集', nil]
  end

  def update
    @article = Article.find(params[:id])
    begin
      Article.transaction do
        p = article_params
        p[:headline] = get_headline(p[:remark])
        @article.update!(p)
      end
      redirect_to @article, notice: '記事を投稿しました。'
    rescue => e
      @bread_crumb = get_bread_curmb(@article.parent)
      @bread_crumb << [@article.directory? ? 'カテゴリ編集' : '記事編集', nil]
      flash[:notice] = e.message
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path(parent_id: @article.parent_id), notice: '記事を削除しました。'
  end

private

  def get_headline(remark)
    headline = helpers.sanitize(remark, :tags => %w(p br)).gsub('<br>', "<br>\n").gsub('</p>', "</p>\n")
    headline = helpers.strip_tags(headline)
    result = ''
    headline.each_char do |c|
      if (result + c).bytesize > Article::HEADLINE_BYTESIZE
        break
      end
      result += c
    end
    result
  end

  def get_bread_curmb(parent)
    bread_crumb = [['記事一覧', articles_path]]
    if parent.present?
      parents = parent.parents
      parents << parent
      parents.each do |article|
        bread_crumb << [article.title, articles_path(parent_id: article.id)]
      end
    end
    bread_crumb
  end

  def article_params
    params.require(:article).permit(:title, :remark, :directory, :parent_id, :group_id, :auth, :permit_comment)
  end
end
