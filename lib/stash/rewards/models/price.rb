# frozen_string_literal: true

module Stash
  module Rewards
    module Models
      class Price
        attr_reader :label, :price, :availability

        def initialize(price_payload)
          @label = price_payload['label'] || ''
          @price = price_payload['price'] || 0
          @availability = price_payload['availability']
        end
      end
    end
  end
end
