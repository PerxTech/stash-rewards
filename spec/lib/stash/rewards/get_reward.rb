# typed: false
# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::GetReward do
  let(:config) do
    Stash::Rewards::Config.new({ api_key: '123', authorization: '456', api_domain: 'https://ext-stg.api.stashnextgen.io' })
  end
  let(:get_reward) { described_class.new(config) }
  let(:campaign_id) { 'asd123qwe' }
  let(:reward_id) { '625d423fa02da70009bdbd11' }

  before do
    stub_request(:get, "https://ext-stg.api.stashnextgen.io/campaigns/#{campaign_id}/rewards/#{reward_id}")
      .with(headers: { 'Authorization' => '456',
                       'Content-Type' => 'application/json',
                       'User-Agent' => 'Faraday v1.10.0',
                       'X-Api-Key' => '123' })
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
  end

  describe '#call' do
    let(:fixture_json) { JSON.parse(fixture('get_reward.json').read) }

    it 'tries to get the reward available for the campaign' do
      response = get_reward.call(campaign_id: campaign_id, reward_id: reward_id)
      expect(response.payload).to eq fixture_json
    end
  end
end
