# frozen_string_literal: true

require_relative '../rewards'

require 'faraday'
require 'faraday_curl'
require 'logger'

module Stash
  module Rewards
    class ApiWrapper
      def initialize(config)
        @config = config
      end

      def headers
        {
          'x-api-key' => config.api_key,
          'Content-Type' => 'application/json',
          'Authorization' => config.authorization
        }
      end

      def api_wrapper
        logger = Logger.new(STDOUT)
        @api_wrapper ||= Faraday.new(url: config.api_domain, headers: headers) do |f|
          f.request :curl, logger, :warn
        end
      end
    end
  end
end
