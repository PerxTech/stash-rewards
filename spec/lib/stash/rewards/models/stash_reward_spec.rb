# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Stash::Rewards::Models::StashReward do
  subject { described_class }

  let(:object) { subject.new(fixture_json) }

  let(:fixture_json) { JSON.parse(fixture('get_reward.json').read) }

  let(:reward_name) { fixture_json['rewardName'] }
  let(:reward_id) { fixture_json['rewardId'] }
  let(:description) { fixture_json['description'] }
  let(:prices) { fixture_json['denominations'] }

  describe '.initialize' do
    it 'sets the reward_name' do
      expect(object.reward_name).to eq reward_name
    end

    it 'sets the reward_id' do
      expect(object.reward_id).to eq reward_id
    end

    it 'sets the description' do
      expect(object.description).to eq description
    end

    it 'sets the prices' do
      expect(object.prices).to eq prices
    end
  end
end
