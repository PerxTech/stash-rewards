# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::V4::StashService::CreateUser, type: :service do
  subject { described_class }

  let(:object) { subject.new(identifier) }

  let!(:setting) {
    create(:setting, key: 'stash_integration',
                     json_value: {
                       'base_url' => 'https://ext-stg.api.stashnextgen.io',
                       'api_key' => SecureRandom.hex(21),
                       'authorization' => SecureRandom.hex(13)
                     })
  }

  let!(:user_account) { create(:user_account) }

  let(:base_url) { setting.json_value['base_url'] }
  let(:api_key) { setting.json_value['api_key'] }
  let(:authorization) { setting.json_value['authorization'] }
  let(:identifier) { user_account.identifier }

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
                'stash_integration', 'create_user.json')
    }
    let(:fixture_json) do
      response = nil
      file = File.open(fixture_path, 'r') do |file|
        response = JSON.parse(file.read).with_indifferent_access
      end
      response
    end

    before do
      allow(object).to receive(:create_user).and_return(fixture_json)
    end

    it 'returns the user refId and userId' do
      object.call

      expect(object).to have_received(:create_user).once
    end
  end

  describe '#create_user' do
    let(:fixture_path) {
      File.join(Rails.root, 'spec', 'fixtures', 'dashboard_v4',
                'stash_integration', 'create_user.json')
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

      body = [{
        refId: user_account.identifier,
        firstName: user_account.first_name,
        lastName: user_account.last_name,
        status: user_account.state,
        email: user_account.email,
        phoneNumber: user_account.phone
      }].to_json

      stub_request(:post, "#{base_url}/users")
      .with(
        headers: headers, body: body
      )
      .to_return(status: 200, body: fixture_json.to_json, headers: {})
    end

    it 'responds with valid response' do
      expect(object.send(:create_user)).to eq(fixture_json)
    end
  end
end
