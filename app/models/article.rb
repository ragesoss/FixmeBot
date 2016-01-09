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
    # make_screenshot
    Tweet.new(tweet_text)
    self.tweeted = true
    save
  end

  def screenshot_path
    "screenshots/#{escaped_title}.png"
  end

  def twitter_card_description
    "#{views} views per day, with a quality rating of #{quality}/100. This article needs help."
  end

  private
  # CGI.escape will convert spaces to '+' which will break the URL
  def escaped_title
    title.tr(' ', '_')
  end

  def views
    average_views.to_i
  end

  def quality
    wp10.to_i
  end

  def url
    "https://en.wikipedia.org/wiki/#{CGI.escape(escaped_title)}"
  end

  def mobile_url
    "https://en.m.wikipedia.org/wiki/#{CGI.escape(escaped_title)}"
  end

  def make_screenshot
    webshot = Webshot::Screenshot.instance
    webshot.capture mobile_url, "public/#{screenshot_path}",
                    width: 800, height: 800, allowed_status_codes: [404]
  end

  def tweet_text
    # title + 2 + views + 31 + [1-2] + 6 + 23 + 1 + 6 =
    "\"#{title}\": #{views} views per day, quality rating #{quality}/100. #{url} #fixme"
  end
end
