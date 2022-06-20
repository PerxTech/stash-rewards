# frozen_string_literal: true

module Stash
  module Rewards
    class Config
      attr_reader :api_key, :authorization, :api_domain

      def initialize(options = {})
        @api_key = options[:api_key]
        @authorization = options[:authorization]
        @api_domain = options[:api_domain]
      end
    end
  end
end
