require 'wikipedia_twitterbot'

Article.connect_to_database 'fixmebot'

class FixmeBot
  def initialize(dry_run: false)
    @dry_run = dry_run
  end

  def tweet_something
    control = Article.fetch_new_article(min_views: 300, max_wp10: 30, count: 1000)
    pp '--- CONTROL ---'
    pp control
    article = Article.fetch_new_article(min_views: 300, max_wp10: 30, count: 1000)
    pp '--- EXPERIMENT ---'
    pp article
  end
end
