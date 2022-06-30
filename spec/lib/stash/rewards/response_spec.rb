# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::Response do
  subject { described_class }

  context 'when response is valid with no errors' do
    let(:response) { fixture('stash_api_success.json').read }
    let(:faraday_response) { Faraday::Response.new(env) }
    let(:env) do
      Faraday::Env.from(status: 200, body: response, response_headers: { 'Content-Type' => 'application/json' })
    end

    let(:object) { subject.new(faraday_response) }

    it 'does not contains any error' do
      expect(object.error?).to eq false
    end

    it 'returns the payload' do
      expect(object.payload).to eq JSON.parse(response)
    end

    it 'returns the status' do
      expect(object.status).to eq 200
    end

    it 'contains the body' do
      expect(object.body).to eq response
    end

    it 'returns 0 as error code' do
      expect(object.error_code).to eq 0
    end

    it 'returns no error message' do
      expect(object.error_message).to eq nil
    end
  end

  context 'when response is valid with validation errors' do
    let(:response) { fixture('stash_api_validation_error.json').read }
    let(:faraday_response) { Faraday::Response.new(env) }
    let(:env) do
      Faraday::Env.from(status: 201, body: response, response_headers: { 'Content-Type' => 'application/json' })
    end

    let(:object) { subject.new(faraday_response) }

    it 'contains error' do
      expect(object.error?).to eq true
    end

    it 'returns the payload' do
      expect(object.payload).to eq JSON.parse(response)
    end

    it 'returns the status' do
      expect(object.status).to eq 201
    end

    it 'contains the body' do
      expect(object.body).to eq response
    end

    it 'returns error code other than 0' do
      expect(object.error_code).not_to eq 0
    end

    it 'returns error message' do
      expect(object.error_message).not_to eq nil
    end
  end

  context 'when response is valid with errors with message' do
    let(:response) { fixture('stash_api_failed_request.json').read }
    let(:faraday_response) { Faraday::Response.new(env) }
    let(:env) do
      Faraday::Env.from(status: 404, body: response, response_headers: { 'Content-Type' => 'application/json' })
    end

    let(:object) { subject.new(faraday_response) }

    it 'contains error' do
      expect(object.error?).to eq true
    end

    it 'returns the payload' do
      expect(object.payload).to eq JSON.parse(response)
    end

    it 'returns the status' do
      expect(object.status).to eq 404
    end

    it 'contains the body' do
      expect(object.body).to eq response
    end

    it 'returns 0 as error code' do
      expect(object.error_code).to eq 0
    end

    it 'returns error message' do
      expect(object.error_message).not_to eq nil
    end
  end

  context 'when response is invalid without error message' do
    let(:response) { fixture('stash_api_broken.json').read }
    let(:faraday_response) { Faraday::Response.new(env) }
    let(:env) do
      Faraday::Env.from(status: 500, body: response, response_headers: { 'Content-Type' => 'application/json' })
    end

    let(:object) { subject.new(faraday_response) }

    it 'contains error' do
      expect(object.error?).to eq true
    end

    it 'returns the payload' do
      expect(object.payload).to eq JSON.parse(response)
    end

    it 'returns the status' do
      expect(object.status).to eq 500
    end

    it 'contains the body' do
      expect(object.body).to eq response
    end

    it 'returns 0 as error code' do
      expect(object.error_code).to eq 0
    end

    it 'returns error message' do
      expect(object.error_message).to eq nil
    end
  end
end
