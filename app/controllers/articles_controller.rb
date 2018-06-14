class ArticlesController < ApplicationController
  before_action :set_target_user, only: [:index, :show]
  before_action :set_target_group, only: [:index, :show]

  def index
    @articles = Article.accessible(current_user.id).where(parent_id: nil)
    @bread_crumb = get_bread_curmb(@parent, @target_group, @target_user)
  end

  def show
    @article = Article.accessible(current_user.id).find(params[:id])
    @bread_crumb = get_bread_curmb(@article, @target_group, @target_user)
    if @article.directory?
      @parent = @article
      @articles = Article.accessible(current_user.id).where(parent_id: @parent.try(:id))
      render 'index'
    end
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
      raise 'not permitted' if @article.user_id != current_user.id
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
    begin
      raise 'not permitted' if @article.user_id != current_user.id
      @article.destroy
      redirect_to article_path(@article.parent), notice: '記事を削除しました。'
    rescue => e
      redirect_to article_path(parent_id: @article.parent), alert: e.message
    end
  end

private

  def set_target_user
    @target_user = User.find_by_id(params[:user_id])
  end

  def set_target_group
    @target_group = Group.find_by_id(params[:group_id])
  end

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

  def get_bread_curmb(article, target_group=nil, target_user=nil)
    bread_crumb = []
    if target_group.present?
      bread_crumb << [target_group.name, nil]
    elsif target_user.present?
      bread_crumb << [target_user.nickname, nil]
    end
    bread_crumb << ['記事一覧', helpers.target_articles_path(target_group, target_user)]
    if article.present?
      parents = article.parents
      parents.each do |article2|
        bread_crumb << [article2.title, helpers.target_article_path(article2, target_group, target_user)]
      end
      bread_crumb << [article.title, article.directory? ? article : nil]
    end
    bread_crumb
  end

  def article_params
    params.require(:article).permit(:title, :remark, :directory, :parent_id, :group_id, :auth, :permit_comment)
  end
end
