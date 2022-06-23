# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::CreateUser do
  let(:config) do
    Stash::Rewards::Config.new({ api_key: '123', authorization: '456', api_domain: 'https://ext-stg.api.stashnextgen.io' })
  end
  let(:create_user) { described_class.new(config) }
  let(:user_identifier) { '200002001176518' }
  let(:user_payload) do
    [
      {
        "refId": user_identifier,
        "firstName": user_identifier,
        "lastName": user_identifier,
        "status": 'ACTIVE',
        "email": "#{user_identifier}@mailinator.com",
        "phoneNumber": '+6511112223',
        "address": {
          "countryCode": 'US',
          "street": 'string',
          "suburb": 'string',
          "state": 'string',
          "postCode": 'string'
        }
      }
    ]
  end

  before do
    stub_request(:post, 'https://ext-stg.api.stashnextgen.io/users')
      .with(headers: { 'Accept' => '*/*',
                       'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                       'Authorization' => '456',
                       'Content-Type' => 'application/json',
                       'User-Agent' => 'Faraday v1.10.0',
                       'X-Api-Key' => '123' },
            body: user_payload.to_json)
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
  end

  describe '#call' do
    let(:fixture_json) { JSON.parse(fixture('create_user.json').read) }

    it 'returns the user refId and userId' do
      response = create_user.call(user_identifier: user_identifier)
      expect(response).to eq fixture_json
    end
  end
end
