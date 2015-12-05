class Datacycle
  def self.keepgrabbing
    i = 0
    loop do
      i += 1
      Rails.logger.info i
      articles = FindArticles.at_random(count: 1000)
      pp articles.count
      articles = DiscardRedirects.from(articles)
      pp articles.count
      articles = HighPageviews.from_among(articles, min_views: 300)
      pp articles.count
      articles = Ores.discard_high_revision_scores(articles, max_wp10: 30)
      pp articles.count
      Article.import articles
    end
  end
end
