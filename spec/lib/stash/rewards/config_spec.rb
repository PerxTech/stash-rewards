# typed: false
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::Config do
  let(:config) { described_class.new({ api_key: '123', authorization: '456', api_domain: 'https://localhost' }) }

  it 'builds the configuration object' do
    expect(config.api_key).to eq '123'
    expect(config.authorization).to eq '456'
    expect(config.api_domain).to eq 'https://localhost'
  end
end
