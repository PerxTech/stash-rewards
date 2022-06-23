# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class EnrolUserInCampaign < ApiWrapper
      def call(campaign_id:, user_identifier:)
        response = api_wrapper.post("campaigns/#{campaign_id}/users") do |req|
          req.body = user_payload(user_identifier)
        end
        parsed_response = JSON.parse(response.body)

        raise Stash::Rewards::Error, parsed_response['message'] unless response.success?

        parsed_response
      rescue Faraday::Error => e
        raise Stash::Rewards::Error, e.message
      end

      private

      def user_payload(user_identifier)
        [{ refId: user_identifier }].to_json
      end
    end
  end
end
