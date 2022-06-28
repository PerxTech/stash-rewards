# frozen_string_literal: true

module Stash
  module Rewards
    class StashReward
      attr_reader :reward_name, :reward_id, :description, :prices

      def initialize(reward_payload)
        @reward_name = reward_payload['rewardName']
        @reward_id = reward_payload['rewardId']
        @description = reward_payload['description']
        @prices = reward_payload['denominations'] || []
      end
    end
  end
end
