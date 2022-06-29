# frozen_string_literal: true

module Stash
  module Rewards
    module Models
      class Image
        attr_reader :landscape, :logo, :portrait, :thumbnail

        def initialize(image_payload)
          @landscape = image_payload['landscape']
          @logo = image_payload['logo']
          @portrait = image_payload['portrait']
          @thumbnail = image_payload['thumbnail']
        end
      end
    end
  end
end
