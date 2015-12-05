require "#{Rails.root}/app/main/wiki"

class FindArticles
  ################
  # Entry points #
  ################

  def self.by_ids(ids)
    existing_ids = Article.all.pluck(:id)
    ids -= existing_ids
    page_data = get_pages(ids)
    article_data = page_data.select { |page| page['ns'] == 0 }
    article_data.select! { |page| existing_ids.exclude?(page['pageid']) }

    articles = []
    article_data.each do |article|
      revision = article['revisions'][0]
      articles << Article.new(id: article['pageid'],
                              title: article['title'],
                              latest_revision: revision['revid'],
                              latest_revision_datetime: revision['timestamp'])
    end
    articles
  end

  def self.at_random(count: 100)
    # As of December 2015, recently created articles have page ids under
    # 50_000_000.
    ids = count.times.map { Random.rand(60_000_000) }
    by_ids(ids)
  end

  ####################
  # Internal methods #
  ####################

  def self.revisions_query(article_ids)
    { prop: 'revisions',
      pageids: article_ids,
      rvprop: 'userid|ids|timestamp'
    }
  end

  def self.get_pages(article_ids)
    pages = {}
    article_ids.each_slice(50) do |fifty_ids|
      rev_query = revisions_query(fifty_ids)
      rev_response = Wiki.query rev_query
      pages.merge! rev_response.data['pages']
    end
    pages.values
  end
end
