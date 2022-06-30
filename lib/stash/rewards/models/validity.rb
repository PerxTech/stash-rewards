# frozen_string_literal: true

module Stash
  module Rewards
    module Models
      class Validity
        def initialize(validity_payload)
          @duration = validity_payload['duration']
          @date = validity_payload['date']
        end

        # NOTE: assuming date is a fixed date of validity and
        # duration is number of days after issuance
        def valid_until(issuance_date = Time.now)
          return nil if @duration.nil? && @date.nil?
          return @date if @date

          issuance_date + @duration * 24 * 60 * 60
        end
      end
    end
  end
end
