require "#{Rails.root}/app/main/wiki_pageviews"

class HighPageviews
  def self.from_among(articles, min_views: 300)
    average_views = {}

    articles.each_slice(50) do |fifty_articles|
      threads = fifty_articles.each_with_index.map do |article, i|
        Thread.new(i) do
          title = article.title.tr(' ', '_')
          average_views[article.id] = WikiPageviews.average_views_for_article(title)
        end
      end
      threads.each(&:join)
    end

    timestamp = Time.now.utc
    update_average_views(articles, average_views, timestamp)
    articles.reject! { |article| article.average_views.nil? }
    articles.select! { |article| article.average_views > min_views }
    articles
  end

  def self.update_average_views(articles, average_views, average_views_updated_at)
    articles.each do |article|
      article.average_views_updated_at = average_views_updated_at
      article.average_views = average_views[article.id]
    end
  end
end
