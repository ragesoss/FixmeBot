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
    @texts = @client.search(search_query).first(200).map(&:text)
    @hashtags = Hash.new { |h, k| h[k] = 0 }
    @texts.select! { |text| text.match(/#/) }
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
end
