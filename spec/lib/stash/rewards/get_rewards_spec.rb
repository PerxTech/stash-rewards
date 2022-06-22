# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::V4::StashService::GetRewards, type: :service do
  subject { described_class }

  let(:object) { subject.new({ base_url: base_url, api_key: api_key, authorization: authorization }) }

  let!(:setting) {
    create(:setting, key: 'stash_integration',
                     json_value: {
                       'base_url' => 'https://ext-stg.api.stashnextgen.io',
                       'api_key' => SecureRandom.hex(21),
                       'campaign_id' => SecureRandom.hex(13),
                       'authorization' => SecureRandom.hex(13)
                     })
  }

  let(:base_url) { setting.json_value['base_url'] }
  let(:api_key) { setting.json_value['api_key'] }
  let(:authorization) { setting.json_value['authorization'] }
  let(:campaign_id) { setting.json_value['campaign_id'] }

  describe '.initialize' do
    it 'sets the base_url' do
      expect(object.base_url).to eq base_url
    end

    it 'sets the api_key' do
      expect(object.api_key).to eq api_key
    end

    it 'sets the authorization token' do
      expect(object.authorization).to eq authorization
    end
  end

  describe '#call' do
    let(:fixture_path) { File.join(Rails.root, 'spec', 'fixtures', 'dashboard_v4', 'stash_integration', 'get_rewards.json') }
    let(:fixture_json) do
      response = nil
      file = File.open(fixture_path, 'r') do |file|
        response = JSON.parse(file.read).with_indifferent_access
      end
      response
    end

    before do
      allow(object).to receive(:fetch_rewards).with(campaign_id).and_return(fixture_json)
    end

    it 'returns the rewards list' do
      object.call(campaign_id)

      expect(object).to have_received(:fetch_rewards).with(campaign_id).once
    end
  end

  describe '#fetch_rewards' do
    let(:fixture_path) { File.join(Rails.root, 'spec', 'fixtures', 'dashboard_v4', 'stash_integration', 'get_rewards.json') }
    let(:fixture_json) do
      response = nil
      file = File.open(fixture_path, 'r') do |file|
        response = JSON.parse(file.read).with_indifferent_access
      end
      response
    end

    before do
      stub_request(:get, "#{base_url}/campaigns/#{campaign_id}/rewards")
      .with(
        headers: {
          'x-api-key' => api_key,
          'Content-Type' => 'application/json',
          'Authorization' => authorization,
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
    end

    it 'responds with valid response' do
      expect(object.send(:fetch_rewards, campaign_id)).to eq(fixture_json)
    end
  end
end
