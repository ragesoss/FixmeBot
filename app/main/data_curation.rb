class DataCuration
  def self.purge_untweeted_articles
    Article.where(tweeted: nil).destroy_all
  end
end
