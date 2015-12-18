require 'mediawiki_api'

#= This class is for getting data directly from the Wikipedia API.
class Wiki
  ################
  # Entry points #
  ################

  # General entry point for making arbitrary queries of the Wikipedia API
  def self.query(query_parameters, opts = {})
    wikipedia('query', query_parameters, opts)
  end

  def self.get_page_content(page_title, opts = {})
    response = wikipedia('get_wikitext', page_title, opts)
    response.status == 200 ? response.body : nil
  end

  ###################
  # Private methods #
  ###################
  class << self
    private

    def wikipedia(action, query, opts = {})
      tries ||= 3
      @mediawiki = api_client(opts)
      @mediawiki.send(action, query)
    rescue StandardError => e
      tries -= 1
      typical_errors = [Faraday::TimeoutError,
                        Faraday::ConnectionFailed,
                        MediawikiApi::HttpError]
      if typical_errors.include?(e.class)
        retry if tries >= 0
      else
        raise e
      end
    end

    def api_client(opts)
      site = opts[:site]
      language = opts[:language] || 'en'

      if site
        url = "https://#{site}/w/api.php"
      else
        url = "https://#{language}.wikipedia.org/w/api.php"
      end
      MediawikiApi::Client.new url
    end
  end
end
