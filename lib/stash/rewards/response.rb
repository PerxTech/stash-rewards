# frozen_string_literal: true

module Stash
  module Rewards
    class Response
      def initialize(faraday_response)
        @response = faraday_response
      end

      def error?
        !@response.success? || (error_code != 0)
      end

      def payload
        @payload ||= JSON.parse(body)
      end

      def status
        @status ||= @response.status
      end

      def body
        @body ||= @response.body
      end

      def error_code
        @error_code ||= payload.dig('error', 'code').to_i
      end

      def error_message
        api_error_message || error_payload
      end

      private

      def error_payload
        error_data = payload.dig('error', 'data')
        return nil if error_data.empty?

        error_data.map { |error| error['message'] }.join(', ')
      end

      def api_error_message
        payload['message']
      end
    end
  end
end
