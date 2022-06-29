# frozen_string_literal: true

require_relative 'price'
require_relative 'image'
require_relative 'validity'

module Stash
  module Rewards
    module Models
      class StashReward
        attr_reader :id, :name, :format, :description, :code, :market,
                    :instructions, :long_description, :terms_and_conditions,
                    :prices, :images

        def initialize(reward_payload)
          @id = reward_payload['rewardId']
          @name = reward_payload['rewardName']
          @format = reward_payload['rewardFormat']
          @description = reward_payload['description']
          @code = reward_payload['rewardCode']
          @market = reward_payload['market']
          @instructions = reward_payload['instruction']
          @long_description = reward_payload['longDescription']
          @terms_and_conditions = reward_payload['termsAndConditions']
          @prices = load_prices(reward_payload['denominations'])
          @images = load_images(reward_payload['images'])
          @validity = ::Stash::Rewards::Models::Validity.new(reward_payload['validity'])
        end

        def valid_until(issuance_date = Time.now)
          @validity.valid_until(issuance_date)
        end

        private

        def load_prices(prices_list = [])
          prices_list.map { |price| ::Stash::Rewards::Models::Price.new(price) }
        end

        def load_images(images_list = [])
          images_list.map { |image| ::Stash::Rewards::Models::Image.new(image) }
        end
      end
    end
  end
end
