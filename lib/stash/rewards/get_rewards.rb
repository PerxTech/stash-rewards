# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class GetRewards < ApiWrapper
      def initialize(options = {})
        super
      end

      def call(campaign_id, page_no, page_size)
        response = api_wrapper.get("campaigns/#{campaign_id}/rewards") do |req|
          req.params = query_params(page_no, page_size)
        end
        parsed_response = JSON.parse(response.body)
        p parsed_response
        p response.inspect
        # raise Stash::Rewards::Error, parsed_response unless response.success?

        parsed_response
      rescue Faraday::Error => e
        # raise Stash::Rewards::Error, e.message
        p e.inspect
      end

      private

      def query_params(page_no, page_size)
        {
          'page' => page_no || 0,
          'size' => page_size || 500
        }
      end
    end
  end
end
