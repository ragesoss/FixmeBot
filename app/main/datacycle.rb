class Datacycle
  def self.keepgrabbing
    sleep 5
    puts "Datacycle started: PID #{Process.pid}"

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
    puts "starting cycle #{i}..."
    articles = FindArticles.at_random(count: 10000)
    puts "#{articles.count} mainspace articles found"
    articles = DiscardRedirects.from(articles)
    puts "#{articles.count} are not redirects"
    articles = HighPageviews.from_among(articles, min_views: 300)
    puts "#{articles.count} of those have high page views"
    articles = Ores.discard_high_revision_scores(articles, max_wp10: 30)
    if articles.count > 0
      puts "#{articles.count} tweetable prospect(s) found!"
    else
      puts "no tweetable articles found in that cycle"
    end
    Article.import articles
  end
end
