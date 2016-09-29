#= Imports revision scoring data from ores.wmflabs.org
class Ores
  ################
  # Entry points #
  ################
  def self.discard_high_revision_scores(articles, max_wp10: 30)
    add_revision_scores(articles)
    articles.select! { |article| !article.wp10.nil? }
    articles.select! { |article| article.wp10 < max_wp10 }
    articles
  end

  ###############
  # Other stuff #
  ###############

  # This should take up to 50 rev_ids per batch
  def self.add_revision_scores(articles)
    scores = {}
    rev_ids = articles.map { |article| article.latest_revision }

    threads = rev_ids.each_slice(50).with_index.map do |fifty_rev_ids, i|
      Thread.new(i) do
        thread_scores = get_revision_scores fifty_rev_ids
        scores.merge!(thread_scores)
      end
    end
    threads.each(&:join)

    scores.each do |rev_id, results|
      probability = results['probability']
      next if probability.nil?
      article = articles.detect { |article| article.latest_revision == rev_id.to_i }
      next if article.nil?
      article.wp10 = weighted_mean_score(probability)
    end
  end

  def self.weighted_mean_score(probability)
    mean = probability['FA'] * 100
    mean += probability['GA'] * 80
    mean += probability['B'] * 60
    mean += probability['C'] * 40
    mean += probability['Start'] * 20
    mean += probability['Stub'] * 0
    mean
  end

  def self.query_url(rev_ids)
    base_url = 'https://ores.wikimedia.org/v1/scores/enwiki/wp10/?revids='
    rev_ids_param = rev_ids.map(&:to_s).join('|')
    url = base_url + rev_ids_param
    url = URI.encode url
    url
  end

  ###############
  # API methods #
  ###############
  def self.get_revision_scores(rev_ids)
    # TODO: i18n
    url = query_url(rev_ids)
    response = Net::HTTP.get(URI.parse(url))
    scores = JSON.parse(response)
    scores
  rescue StandardError => error
    typical_errors = [Errno::ETIMEDOUT,
                      Net::ReadTimeout,
                      Errno::ECONNREFUSED,
                      JSON::ParserError]
    raise error unless typical_errors.include?(error.class)
    return {}
  end
end
