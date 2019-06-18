require 'wikipedia_twitterbot'

Article.connect_to_database 'fixmebot'

class FixmeBot
  def initialize(dry_run: false, article: nil)
    @article = article
    @dry_run = dry_run
  end

  def tweet_something
    prepare_experiment
    if @dry_run
      pp tweet_text
    else
      send_tweet
    end
  end

  def prepare_experiment
    @control = Article.fetch_new_article(min_views: 100, max_wp10: 30, count: 10000)
    pp '--- CONTROL ---'
    pp @control.title
    @article = Article.fetch_new_article(min_views: 100, max_wp10: 30, count: 10000)
    pp '--- EXPERIMENT ---'
    pp @article.title
    Experiment.new_article_pair(@article, @control)
  end

  def send_tweet
    @article.tweet_with_screenshot tweet_text
  end

  def tweet_text
    # title + 2 + views + 31 + [1-2] + 6 + 23 + 1 + 6 =
    hashtag = @article.hashtag
    views = "#{@article.average_views} views/day"
    "\"#{@article.title}\": #{views}\n\n Please help improve it!\n\n #{edit_url} #{hashtag}"
  end

  def escaped_title
    # CGI.escape will convert spaces to '+' which will break the URL
    CGI.escape(@article.title.tr(' ', '_'))
  end

  def edit_url
    # Includes the summary preload #FixmeBot, so that edits can be tracked:
    # http://tools.wmflabs.org/hashtags/search/fixmebot
    "https://en.wikipedia.org/wiki/#{escaped_title}?veaction=edit&summary=%23FixmeBot"
  end
end
