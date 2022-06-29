# typed: strict
# frozen_string_literal: true

require_relative '../rewards'

require 'faraday'
require 'json'

module Stash
  module Rewards
    class ApiWrapper
      sig { params(config: T::Hash[Symbol, String], url_encoded: T::Boolean).void }
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
        @api_wrapper ||= Faraday.new(url: @config.api_domain, headers: headers) do |f|
          f.adapter :typhoeus
          f.request :url_encoded
        end
      end
    end
  end
end
