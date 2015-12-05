class Datacycle
  def self.keepgrabbing
    i = 0
    loop do
      i += 1
      pp "starting cycle #{i}"
      articles = FindArticles.at_random(count: 1000)
      pp "#{articles.count} mainspace articles found"
      articles = DiscardRedirects.from(articles)
      pp "#{articles.count} are not redirects"
      articles = HighPageviews.from_among(articles, min_views: 300)
      pp "#{articles.count} of those have high page views"
      articles = Ores.discard_high_revision_scores(articles, max_wp10: 30)
      if articles.count > 0
        pp "#{articles.count} tweetable prospect(s) found!"
      else
        pp "no tweetable articles found in that cycle"
      end
      Article.import articles
    end
  end
end
