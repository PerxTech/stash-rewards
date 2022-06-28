# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::IssueVoucher do
  let(:config) do
    Stash::Rewards::Config.new({ api_key: '123', authorization: '456', api_domain: 'https://ext-stg.api.stashnextgen.io' })
  end
  let(:issue_voucher) { described_class.new(config) }
  let(:user_identifier) { '200002001176518' }
  let(:campaign_id) { 'asd123qwe' }
  let(:order_payload) do
    {
      "userInformation": {},
      "products": [
        {
          "rewardId": stash_reward_id,
          "price": 0,
          "quantity": 1
        }
      ]
    }
  end
  let(:stash_reward_id) { '111222333' }

  before do
    stub_request(:post, "https://ext-stg.api.stashnextgen.io/campaigns/#{campaign_id}/users/refId_#{user_identifier}/rewards/order")
      .with(headers: { 'Authorization' => '456',
                       'Content-Type' => 'application/json',
                       'User-Agent' => 'Faraday v1.10.0',
                       'X-Api-Key' => '123' },
            body: order_payload.to_json)
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
  end

  describe '#call' do
    let(:fixture_json) { JSON.parse(fixture('issue_voucher.json').read) }

    before do
      allow(issue_voucher).to receive(:reward_price).with(stash_reward_id, campaign_id).and_return(0)
    end

    it 'checks for the reward price' do
      issue_voucher.call(campaign_id: campaign_id, user_identifier: user_identifier, reward_id: stash_reward_id)

      expect(issue_voucher).to have_received(:reward_price).with(stash_reward_id, campaign_id).once
    end

    it 'returns the redemption Id list' do
      response = issue_voucher.call(campaign_id: campaign_id, user_identifier: user_identifier, reward_id: stash_reward_id)

      expect(response.payload).to eq fixture_json
    end
  end
end
