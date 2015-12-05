class DiscardRedirects
  def self.from(articles)
    pages = {}
    articles.each_slice(50) do |fifty_articles|
      ids = fifty_articles.map(&:id)
      page_info_response = Wiki.query page_info_query(ids)
      pages.merge! page_info_response.data['pages']
    end

    articles.each do |article|
      info = pages[article.id.to_s]
      next unless info
      if info['redirect']
        article.redirect = true
      else
        article.redirect = false
      end
    end

    articles.select! { |article| article.redirect == false }
    articles
  end

  def self.page_info_query(page_ids)
    { prop: 'info',
      pageids: page_ids
    }
  end
end
