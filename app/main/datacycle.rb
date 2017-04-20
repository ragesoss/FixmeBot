class Datacycle
  def self.keepgrabbing
    sleep 5
    Rails.logger.info "Datacycle started: PID #{Process.pid}"

    i = 0
    loop do
      i += 1
      cycle(i)
    end
  end

  def self.times(count)
    (1..count).each do |i|
      cycle(i)
    end
  end

  def self.cycle(i)
    Rails.logger.debug "starting cycle #{i}..."
    articles = FindArticles.at_random(count: 10000)
    Rails.logger.debug "#{articles.count} mainspace articles found"
    articles = DiscardRedirects.from(articles)
    Rails.logger.debug "#{articles.count} are not redirects"
    articles = HighPageviews.from_among(articles, min_views: 300)
    Rails.logger.debug "#{articles.count} of those have high page views"
    articles = Ores.discard_high_revision_scores(articles, max_wp10: 30)
    Rails.logger.debug "#{articles.count} of those have low revision scores"
    articles = CategoryFilter.discard_disambiguation_pages(articles)
    Rails.logger.debug "#{articles.count} of those are not disambiguation pages"
    if articles.count > 0
      Rails.logger.info "#{articles.count} tweetable prospect(s) found!"
    else
      Rails.logger.info "no tweetable articles found in that cycle"
    end
    Article.import articles
  end
end
