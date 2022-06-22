# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::V4::StashService::IssueVoucher, type: :service do
  subject { described_class }

  let(:object) { subject.new(identifier) }

  let!(:setting) {
    create(:setting, key: 'stash_integration',
                     json_value: {
                       'base_url' => 'https://ext-stg.api.stashnextgen.io',
                       'api_key' => SecureRandom.hex(21),
                       'campaign_id' => SecureRandom.hex(13),
                       'authorization' => SecureRandom.hex(13)
                     })
  }

  let!(:user_account) { create(:user_account) }
  let!(:reward_campaign) { create(:reward_campaign) }

  let(:base_url) { setting.json_value['base_url'] }
  let(:api_key) { setting.json_value['api_key'] }
  let(:authorization) { setting.json_value['authorization'] }
  let(:identifier) { user_account.identifier }
  let(:campaign_id) { setting.json_value['campaign_id'] }
  let(:stash_reward_id) { reward_campaign.id }

  describe '.initialize' do
    it 'sets the base_url' do
      expect(object.setting.json_value['base_url']).to eq base_url
    end

    it 'sets the api_key' do
      expect(object.setting.json_value['api_key']).to eq api_key
    end

    it 'sets the authorization token' do
      expect(object.setting.json_value['authorization']).to eq authorization
    end

    it 'receives the identifier' do
      expect(object.user_account.identifier).to eq identifier
    end
  end

  describe '#call' do
    let(:fixture_path) {
      File.join(Rails.root, 'spec', 'fixtures', 'dashboard_v4',
                'stash_integration', 'issue_voucher.json')
    }
    let(:fixture_json) do
      response = nil
      file = File.open(fixture_path, 'r') do |file|
        response = JSON.parse(file.read).with_indifferent_access
      end
      response
    end

    before do
      allow(object).to receive(:issue_voucher).with(stash_reward_id).and_return(fixture_json)
    end

    it 'returns the redemption Id list' do
      object.call(stash_reward_id)

      expect(object).to have_received(:issue_voucher).with(stash_reward_id).once
    end
  end

  describe '#issue_voucher' do
    let(:fixture_path) {
      File.join(Rails.root, 'spec', 'fixtures', 'dashboard_v4',
                'stash_integration', 'issue_voucher.json')
    }
    let(:fixture_json) do
      response = nil
      file = File.open(fixture_path, 'r') do |file|
        response = JSON.parse(file.read).with_indifferent_access
      end
      response
    end

    before do
      headers = {
        'accept' => 'application/json',
        'x-api-key' => setting.json_value['api_key'],
        'Authorization' => setting.json_value['authorization'],
        'Content-Type' => 'application/json',
        'User-Agent' => 'Ruby'
      }

      body = {
        products: [
          {
            rewardId: "#{stash_reward_id}",
            price: 0,
            quantity: 0
          }
        ]
      }.to_json

      stub_request(:post, "#{base_url}/campaigns/#{campaign_id}/users/refId_#{identifier}/rewards/order")
      .with(
        headers: headers, body: body
      )
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
    end

    it 'responds with valid response' do
      expect(object.send(:issue_voucher, stash_reward_id)).to eq(fixture_json)
    end
  end
end
