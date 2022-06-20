# frozen_string_literal: true

require_relative 'api_wrapper'

module Stash
  module Rewards
    class CreateUser < ApiWrapper
      def initialize(options = {})
        super
      end

      def call(user_identifier)
        response = api_wrapper.post('users') do |req|
          req.body = user_payload(user_identifier)
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

      def user_payload(user_identifier)
        [
          {
            "refId": user_identifier,
            "firstName": user_identifier,
            "lastName": user_identifier,
            "status": "ACTIVE",
            "email": "#{user_identifier}@mailinator.com",
            "phoneNumber": "+6511112223",
            "address": {
              "countryCode": "US",
              "street": "string",
              "suburb": "string",
              "state": "string",
              "postCode": "string"
            }
          }
        ].to_json
      end
    end
  end
end
