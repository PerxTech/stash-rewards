# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'stash/rewards'
require 'rspec/file_fixtures'
require 'webmock/rspec'

RSpec.configure do |config|
end

WebMock.disable_net_connect!(allow_localhost: true)
