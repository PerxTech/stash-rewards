# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class IssueVoucher < ApiWrapper
      def call(campaign_id:, user_identifier:, reward_id:)
        response = api_wrapper.post("campaigns/#{campaign_id}/users/refId_#{user_identifier}/rewards/order") do |req|
          req.body = order_payload(reward_id)
        end
        parsed_response = JSON.parse(response.body)
        raise Stash::Rewards::Error, parsed_response['message'] unless response.success?

        parsed_response
      rescue Faraday::Error => e
        raise Stash::Rewards::Error, e.message
      end

      private

      def order_payload(reward_id)
        {
          "userInformation": {},
          "products": [
            {
              "rewardId": reward_id,
              "price": 0,
              "quantity": 0
            }
          ]
        }.to_json
      end
    end
  end
end
