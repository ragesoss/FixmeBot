class Article < ActiveRecord::Base
  #################
  # Class methods #
  #################

  def self.last_tweetable
    tweetable.last
  end

  def self.first_tweetable
    tweetable.first
  end

  def self.tweetable
    where('wp10 < ?', 25)
      .where('average_views > ?', 200)
      .where(tweeted: nil)
  end

  ####################
  # Instance methods #
  ####################
  def tweet
    make_screenshot
    screenshot = File.read screenshot_path
    Tweet.new(tweet_text, media: screenshot)
    self.tweeted = true
    save
  end

  def screenshot_path
    "public/screenshots/#{escaped_title}.png"
  end

  def twitter_card_description
    "#{views} views per day, with a quality rating of #{quality}/100. This article needs help."
  end

  def tweet_text
    # title + 2 + views + 31 + [1-2] + 6 + 23 + 1 + 6 =
    ht = hashtag || ''
    body = "\": #{views} views/day, #{quality}% complete. "
    size = 1 + body.size + 24 + ht.size
    shortened_title = title.truncate(138 - size)
    "\"#{shortened_title}#{body}#{edit_url} #{ht}"
  end

  def escaped_title
    # CGI.escape will convert spaces to '+' which will break the URL
    CGI.escape(title.tr(' ', '_'))
  end

  def views
    average_views.to_i
  end

  def quality
    wp10.to_i
  end

  def url
    "https://en.wikipedia.org/wiki/#{escaped_title}"
  end

  def mobile_url
    "https://en.m.wikipedia.org/wiki/#{escaped_title}"
  end

  def edit_url
    # Includes the summary preload #FixmeBot, so that edits can be tracked:
    # http://tools.wmflabs.org/hashtags/search/fixmebot
    "https://en.wikipedia.org/wiki/#{escaped_title}?veaction=edit&summary=%23FixmeBot"
  end

  # phantomjs rasterize.js 'https://en.wikipedia.org/wiki/Selfie' wikip.png 1000px*1000px

  def make_screenshot
    # Use rasterize script to make a screenshot
    %x[phantomjs ../rasterize.js #{mobile_url} #{screenshot_path} 1000px*1000px]
    # Trim any extra blank space, which may or may not be present.
    %x[convert #{screenshot_path} -trim #{screenshot_path}]
  end

  def hashtag
    TwitterClient.new.top_hashtag(title)
  end
end
