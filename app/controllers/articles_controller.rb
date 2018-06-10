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
  end

  def create
    @article = Article.new(article_params)
    @article.user_id = current_user.id
    begin
      Article.transaction do
        @article.save!
      end
      redirect_to articles_path(parent_id: @article.parent_id), notice: '記事を投稿しました。'
    rescue => e
      @bread_crumb = get_bread_curmb(@article.parent)
      flash[:notice] = e.message
      render :new
    end
  end

  def edit
    @article = Article.accessible(current_user.id).find(params[:id])
    @bread_crumb = get_bread_curmb(@article.parent)
  end

  def update
    @article = Article.find(params[:id])
    begin
      Article.transaction do
        @article.update!(article_params)
      end
      redirect_to articles_path(parent_id: @article.parent_id), notice: '記事を投稿しました。'
    rescue => e
      @bread_crumb = get_bread_curmb(@article.parent)
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

  def get_bread_curmb(parent)
    bread_crumb = [['記事一覧', {controller: :articles, action: :index}]]
    if parent.present?
      parents = parent.parents
      parents << parent
      parents.each do |article|
        bread_crumb << [article.title, {controller: :articles, action: :index, parent_id: article.id}]
      end
    end
    bread_crumb
  end

  def article_params
    params.require(:article).permit(:title, :remark, :directory, :parent_id, :group_id, :auth, :permit_comment)
  end
end
