require_relative 'rewards/version'
require_relative 'rewards/api_wrapper'
require_relative 'rewards/config'
require_relative 'rewards/create_user'
require_relative 'rewards/enrol_user_in_campaign'
require_relative 'rewards/get_rewards'
require_relative 'rewards/issue_voucher'

module Stash
  module Rewards
    class Error < StandardError; end
    # Your code goes here...
  end
end
