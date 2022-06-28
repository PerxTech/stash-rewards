# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class GetReward < ApiWrapper
      def call(campaign_id:, reward_id:)
        api_response = api_wrapper.get("campaigns/#{campaign_id}/rewards/#{reward_id}")
        response = Stash::Rewards::Response.new(api_response)
        raise Stash::Rewards::Error, response.error_message if response.error?

        response
      rescue Faraday::Error => e
        raise Stash::Rewards::Error, e.message
      end
    end
  end
end
