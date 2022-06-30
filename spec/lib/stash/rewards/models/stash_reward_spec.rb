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
    it 'sets the reward name' do
      expect(object.name).to eq reward_name
    end

    it 'sets the reward id' do
      expect(object.id).to eq reward_id
    end

    it 'sets the description' do
      expect(object.description).to eq description
    end

    it 'sets the prices' do
      expect(object.prices[0].label).to eq prices[0]['label']
      expect(object.prices[0].price).to eq prices[0]['price']
      expect(object.prices[0].availability).to eq prices[0]['availability']
    end
  end
end
