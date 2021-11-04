class Api::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: %i[create show]
  def index
    articles = Article.get_published_articles(params[:category])
    if articles.any?
      binding.pry
      render json: articles, each_serializer: Articles::IndexSerializer
    else
      render json: { message: 'There are no articles in the database' }, status: 404
    end
  end

  def create
    article = authorize Article.new(article_params.merge(author_ids: [current_user.id] + params[:article][:author_ids]))

    article.category = Category.find_by(name: article.category)
    Article.attach_image(article, params)
    article.save

    if article.persisted?
      render json: { message: "You have successfully added #{article.title} to the site" }, status: 201
    else
      render json: { errors: article.errors.full_messages.to_sentence }, status: 422
    end
  end

  def show
    article = authorize Article.find(params[:id])
    render json: article, serializer: Articles::ShowSerializer
  end

  private

  def article_params
    params.require(:article).permit(:title, :lede, :body, :category, :published, author_ids: [])
  end
end
