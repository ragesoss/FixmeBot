class ArticleController < ApplicationController
  def show
    title = params[:title].tr('_', ' ')
    @article = Article.find_by(title: title)
    render text: 'Not Found', status: 404 if @article.nil? || @article.tweeted != true
  end
end
