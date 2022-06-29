# typed: true
# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class CreateUser < ApiWrapper
      def call(user_identifier:)
        api_response = api_wrapper.post('users') do |req|
          req.body = user_payload(user_identifier)
        end

        response = Stash::Rewards::Response.new(api_response)
        raise Stash::Rewards::Error, response.error_message if response.error?

        response
      rescue Faraday::Error => e
        raise Stash::Rewards::Error, e.message
      end

      private

      def user_payload(user_identifier)
        [
          {
            refId: user_identifier,
            firstName: user_identifier,
            lastName: user_identifier,
            status: 'ACTIVE',
            email: "#{user_identifier}@mailinator.com"
          }
        ].to_json
      end
    end
  end
end
