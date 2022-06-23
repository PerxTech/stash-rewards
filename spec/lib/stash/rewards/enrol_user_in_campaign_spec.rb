# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::EnrolUserInCampaign do
  let(:config) do
    Stash::Rewards::Config.new({ api_key: '123', authorization: '456', api_domain: 'https://ext-stg.api.stashnextgen.io' })
  end
  let(:enrol_user) { described_class.new(config) }
  let(:user_identifier) { '200002001176518' }
  let(:campaign_id) { 'asd123qwe' }
  let(:enrolment_payload) { [{ refId: user_identifier }] }

  before do
    stub_request(:post, "https://ext-stg.api.stashnextgen.io/campaigns/#{campaign_id}/users")
      .with(headers: { 'Accept' => '*/*',
                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'Authorization' => '456',
                       'Content-Type' => 'application/json',
                       'User-Agent' => 'Faraday v1.10.0',
                       'X-Api-Key' => '123' },
            body: enrolment_payload.to_json)
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
  end

  describe '#call' do
    let(:fixture_json) { JSON.parse(fixture('enrol_user_in_campaign.json').read) }

    it 'returns the user refId' do
      response = enrol_user.call(campaign_id: campaign_id, user_identifier: user_identifier)
      expect(response).to eq fixture_json
    end
  end
end
