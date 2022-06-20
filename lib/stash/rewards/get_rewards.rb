# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class GetRewards < ApiWrapper
      def call(campaign_id:, page_no: 0, page_size: 500)
        response = api_wrapper.get("campaigns/#{campaign_id}/rewards") do |req|
          req.params = query_params(page_no, page_size)
        end
        parsed_response = JSON.parse(response.body)

        raise Stash::Rewards::Error, parsed_response unless response.success?

        parsed_response
      rescue Faraday::Error => e
        raise Stash::Rewards::Error, e.message
      end

      private

      def query_params(page_no, page_size)
        {
          page: page_no,
          size: page_size
        }
      end
    end
  end
end
