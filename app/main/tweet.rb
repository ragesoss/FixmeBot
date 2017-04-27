require 'twitter'

# Finds tweetable articles, tweets them
class Tweet
  # Find an article to tweet and tweet it
  def self.anything
    # Randomly tweet either the earlier tweetable Article in the database
    # or the latest.
    # Wikipedia increments page ids over time, so the first ids are the oldest
    # articles and the last ids are the latest.
    if coin_flip
      article = Article.last_tweetable
    else
      article = Article.first_tweetable
    end
    article.tweet
    Rails.logger.info "Tweeted #{article.title}"
  end

  ###############
  # Twitter API #
  ###############
  def initialize(tweet)
    tc = TwitterClient.new
    pp tweet
    tc.client.update(tweet)
    pp 'tweeted'
    tc.add_id_to_tweeted_articles
  end

  ###########
  # Helpers #
  ###########

  def self.coin_flip
    [true, false][rand(2)]
  end
end
