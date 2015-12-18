#= Gets the categories for articles and filters based on that data
class CategoryFilter
  ################
  # Entry points #
  ################
  def self.discard_disambiguation_pages(articles)
    articles.select! { |article| !disambiguation_page?(article) }
    articles
  end

  ###############
  # Other stuff #
  ###############
  def self.category_query(page_id)
    { prop: 'categories',
      cllimit: 500,
      pageids: page_id
    }
  end

  def self.categories_for(article)
    article_id = article.id
    response = Wiki.query category_query(article_id)
    categories = response.data['pages'][article_id.to_s]['categories']
    return unless categories
    categories = categories.map { |cat| cat['title'] }
    categories
  end

  def self.disambiguation_page?(article)
    categories = categories_for(article)
    return false unless categories
    categories_for(article).include?('Category:Disambiguation pages')
  end
end
