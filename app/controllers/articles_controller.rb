class ArticlesController < ApplicationController
  before_action :set_target_user, only: [:index, :show]
  before_action :set_target_group, only: [:index, :show]

  def index
    @article = Article.accessible(current_user_id).where(parent_id: nil)
    if @target_group.present?
      @articles = @article.where(group_id: @target_group.id)
    elsif @target_user.present?
      @articles = @article.where(user_id: @target_user.id)
    else
      @articles = @article.where(user_id: current_user_id)
    end
    @bread_crumb = get_bread_crumb(@parent, @target_group, @target_user)
    breadcrumb = @bread_crumb.map { |v| v[0] }

    respond_to do |format|
      format.html { render :index }
      format.json { render json: {articles: @articles, breadcrumb: breadcrumb}.to_json }
    end
  end

  def show
    @article = Article.accessible(current_user_id).find(params[:id])
    @bread_crumb = get_bread_crumb(@article, @target_group, @target_user)
    breadcrumb = @bread_crumb.map { |v| v[0] }
    if @article.directory?
      @parent = @article
      @articles = Article.accessible(current_user_id).where(parent_id: @parent.try(:id))
      render 'index'
    end

    respond_to do |format|
      format.html { render :show }
      format.json { render json: { article: @article, breadcrumb: breadcrumb }.to_json }
    end
  end

  def new
    @parent = Article.find_by_id(params[:parent_id])
    @article = Article.new(parent_id: @parent.try(:id), directory: params[:directory] == 'true')
    @bread_crumb = get_bread_crumb(@parent)
    @bread_crumb << [@article.directory? ? 'カテゴリ追加' : '記事作成', nil]
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user_id
    @article.headline = get_headline(@article.remark)
    begin
      Article.transaction do
        @article.save!
      end
      redirect_to @article, notice: '記事を投稿しました。'
    rescue => e
      @bread_crumb = get_bread_crumb(@article.parent)
      @bread_crumb << [@article.directory? ? 'カテゴリ追加' : '記事作成', nil]
      flash[:notice] = e.message
      render :new
    end
  end

  def edit
    @article = Article.accessible(current_user_id).find(params[:id])
    @bread_crumb = get_bread_crumb(@article.parent)
    @bread_crumb << [@article.directory? ? 'カテゴリ編集' : '記事編集', nil]
  end

  def update
    @article = Article.find(params[:id])
    begin
      raise 'not permitted' if @article.user_id != current_user_id
      Article.transaction do
        p = article_params
        p[:headline] = get_headline(p[:remark])
        @article.update!(p)
      end
      redirect_to @article, notice: '記事を投稿しました。'
    rescue => e
      @bread_crumb = get_bread_crumb(@article.parent)
      @bread_crumb << [@article.directory? ? 'カテゴリ編集' : '記事編集', nil]
      flash[:notice] = e.message
      render :edit
    end
  end

  def destroy
    @article = Article.find(params[:id])
    begin
      raise 'not permitted' if @article.user_id != current_user_id
      @article.destroy
      redirect_to article_path(@article.parent), notice: '記事を削除しました。'
    rescue => e
      redirect_to article_path(parent_id: @article.parent), alert: e.message
    end
  end

private

  def current_user_id
    current_user.try(:id)
  end

  def authenticate_user!
  end

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

  def get_bread_crumb(article, target_group=nil, target_user=nil)
    bread_crumb = []
    if target_group.present?
      bread_crumb << [target_group.name, nil]
    elsif target_user.present?
      bread_crumb << [target_user.nickname, nil]
    end
    bread_crumb << ['記事一覧', helpers.target_articles_path(target_group, target_user)]
    if article.present?
      parents = article.parents
      parents << article
      parents.each do |article2|
        url = article2.directory? ? helpers.target_article_path(article2, target_group, target_user) : nil
        bread_crumb << [article2.title, url]
      end
    end
    bread_crumb
  end

  def article_params
    params.require(:article).permit(:title, :remark, :directory, :parent_id, :group_id, :auth, :permit_comment)
  end
end
