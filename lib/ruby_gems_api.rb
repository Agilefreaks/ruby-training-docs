require 'httparty'

class RubyGemsApi
  include HTTParty
  base_uri 'rubygems.org'

  class << self
    def gem_info(gem_name)
      get("/api/v1/gems/#{gem_name}.json").parsed_response
    end
  end
end
