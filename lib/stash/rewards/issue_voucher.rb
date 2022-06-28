# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class IssueVoucher < ApiWrapper
      def call(campaign_id:, user_identifier:, reward_id:, quantity: 1)
        price = reward_price(reward_id)

        api_response = api_wrapper.post("campaigns/#{campaign_id}/users/refId_#{user_identifier}/rewards/order") do |req|
          req.body = order_payload(reward_id, quantity, price)
        end
        response = Stash::Rewards::Response.new(api_response)
        raise Stash::Rewards::Error, response.error_message if response.error?

        response
      rescue Faraday::Error => e
        raise Stash::Rewards::Error, e.message
      end

      private

      def reward_price
        reward_response = ::Stash::Rewards::GetReward.call(reward_id)
        response = Stash::Rewards::Response.new(reward_response)
        raise Stash::Rewards::Error, response.error_message if response.error?

        response.payload.dig('denonminations')[0].dig('price')
      end

      def order_payload(reward_id, quantity, price)
        {
          "userInformation": {},
          "products": [
            {
              "rewardId": reward_id,
              "price": price,
              "quantity": quantity
            }
          ]
        }.to_json
      end
    end
  end
end
