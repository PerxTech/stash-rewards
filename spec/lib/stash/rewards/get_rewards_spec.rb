# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::GetRewards do
  let(:config) do
    Stash::Rewards::Config.new({ api_key: '123', authorization: '456', api_domain: 'https://ext-stg.api.stashnextgen.io' })
  end
  let(:get_rewards) { described_class.new(config) }
  let(:campaign_id) { 'asd123qwe' }
  let(:page_no) { 0 }
  let(:page_size) { 500 }

  before do
    stub_request(:get, "https://ext-stg.api.stashnextgen.io/campaigns/#{campaign_id}/rewards?page=#{page_no}&size=#{page_size}")
      .with(headers: { 'Accept' => '*/*',
                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'Authorization' => '456',
                       'Content-Type' => 'application/json',
                       'User-Agent' => 'Faraday v1.10.0',
                       'X-Api-Key' => '123' })
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
  end

  describe '#call' do
    # TODO: This should probably use VCR gem and make an actual request first to get the
    # response payload.
    let(:fixture_json) { JSON.parse(fixture('get_rewards.json').read) }

    context 'when no page_no and page_size are passed' do
      it 'tries to get the rewards available for the campaign with default params' do
        response = get_rewards.call(campaign_id: campaign_id)
        expect(response).to eq fixture_json
      end
    end

    context 'when passing custom page_no and page_size' do
      let(:page_no) { 1 }
      let(:page_size) { 10 }

      it 'takes that in account and passes the correct parameters' do
        response = get_rewards.call(campaign_id: campaign_id, page_no: page_no, page_size: page_size)
        expect(response).to eq fixture_json
      end
    end
  end
end
