# frozen_string_literal: true

require 'faraday'
require 'faraday_curl'
require 'logger'

module Stash
  module Rewards
    class ApiWrapper
      def initialize(options = {})
        @api_key = options[:api_key]
        @authorization = options[:authorization]
        @api_domain = options[:api_domain]
      end

      def headers
        {
          'x-api-key' => @api_key,
          'Content-Type' => 'application/json',
          'Authorization' => @authorization
        }
      end

      def api_wrapper
        logger = Logger.new(STDOUT)
        @api_wrapper ||= Faraday.new(url: @api_domain, headers: headers) do |f|
          f.request :curl, logger, :warn
        end
      end
    end
  end
end
