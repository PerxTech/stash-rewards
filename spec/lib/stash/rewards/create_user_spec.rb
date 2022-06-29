# typed: false
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
        "email": "#{user_identifier}@mailinator.com"
      }
    ]
  end

  before do
    stub_request(:post, 'https://ext-stg.api.stashnextgen.io/users')
      .with(headers: { 'Authorization' => '456',
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
      expect(response.payload).to eq fixture_json
    end
  end
end
