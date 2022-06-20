# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class IssueVoucher < ApiWrapper
      def initialize(options = {})
        super
      end

      def call(campaign_id, user_identifier)
        response = api_wrapper.post("campaigns/#{campaign_id}/users/refId_#{user_identifier}/rewards/order") do |req|
          req.body = order_payload
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

      def order_payload
        {
          "userInformation": {},
          "products": [
            {
              "rewardId": "5f361a79986187000833fb82",
              "price": 0,
              "quantity": 0
            }
          ]
        }.to_json
      end
    end
  end
end
