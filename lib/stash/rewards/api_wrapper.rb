# frozen_string_literal: true

require_relative '../rewards'

require 'faraday'
require 'faraday_curl'
require 'logger'
require 'json'

module Stash
  module Rewards
    class ApiWrapper
      def initialize(config, url_encoded = true)
        @config = config
        @url_encoded = url_encoded
      end

      private

      def headers
        {
          'x-api-key' => @config.api_key,
          'Authorization' => @config.authorization,
          'Content-Type' => 'application/json'
        }
      end

      def api_wrapper
        logger = Logger.new(STDOUT)
        @api_wrapper ||= Faraday.new(url: @config.api_domain, headers: headers) do |f|
          f.request :url_encoded if @url_encoded
          f.request :curl, logger, :warn
        end
      end
    end
  end
end
