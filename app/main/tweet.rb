require 'twitter'

class Tweet
  def self.the_last_article
    article = Article.where('wp10 < ?', 25)
                     .where('average_views > ?', 200)
                     .where(tweeted: nil)
                     .last
    article.tweet
  end

  def initialize(tweet)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['twitter_consumer_key']
      config.consumer_secret = ENV['twitter_consumer_secret']
      config.access_token = ENV['twitter_access_token']
      config.access_token_secret = ENV['twitter_access_token_secret']
    end

    client.update(tweet)
  end
end
