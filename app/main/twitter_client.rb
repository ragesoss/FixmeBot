class TwitterClient
  attr_reader :client
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['twitter_consumer_key']
      config.consumer_secret = ENV['twitter_consumer_secret']
      config.access_token = ENV['twitter_access_token']
      config.access_token_secret = ENV['twitter_access_token_secret']
    end
  end

  def top_hashtag(search_query)
    top_with_count = related_hashtags(search_query).max_by { |h, v| v }
    top_with_count[0] unless top_with_count.nil?
  end

  def related_hashtags(search_query)
    # Get the text of up to 200 tweets from the search query.
    # Twitter may return fewer, even zero, results.
    @texts = @client.search(search_query).first(200).map(&:text)
    # We only care about the ones with hashtags
    @texts.select! { |text| text.match(/#/) }

    # Count the occurences of every hashtag in the search results by building
    # a frequency hash.
    @hashtags = Hash.new { |h, k| h[k] = 0 }
    @texts.each do |text|
      hashtags_in(text).each do |hashtag|
        @hashtags[hashtag] += 1
      end
    end
    @hashtags
  end

  def hashtags_in(text)
    text.scan(/\s(#\w+)/).flatten
  end

  def add_id_to_tweeted_articles
    client.user_timeline('@FixmeBot').each do |t|
      title = t.text[/"(.*)":/, 1]
      article = Article.find_by(title: title)
      article.twitter_status_id = t.id
      article.save
    end
  end
end
