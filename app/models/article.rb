class Article < ActiveRecord::Base
  def url
    escaped_title = self.title.tr(' ', '_')
    "https://en.wikipedia.org/wiki/#{escaped_title}"
  end

  def tweet_text
    title = self.title
    views = self.average_views.to_i
    quality = self.wp10.to_i
    # title + 2 + views + 31 + [1-2] + 6 + 23 + 1 + 6 =
    "\"#{title}\": #{views} views per day, quality rating #{quality}/100. #{url} #fixme"
  end

  def tweet
    Tweet.new(tweet_text)
    self.tweeted = true
    save
  end
end
