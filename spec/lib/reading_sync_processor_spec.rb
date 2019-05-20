# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'mock_redis'
describe ReadingSyncProcessor do
  let(:logger) { double(Logger) }
  before(:all) do
    attributes = {
      "seq_no": '3',
      "temperature": '19',
      "humidity": '73',
      "battery_charge": '5.5'
    }
    REDIS.hmset('reading_queue', 'SBe1GesqoOdBR3Lv107:3', attributes.to_json)
    FactoryGirl.create(:thermostat, household_token: 'SBe1GesqoOdBR3Lv107')
  end
  before { allow(subject).to receive(:loop).and_yield }
  describe '#process' do
    context 'when a redis valid entry pushed to queue' do
      it 'should process and save to db' do
        allow(subject).to receive(:logger).and_return(logger)
        allow(logger).to receive(:info)
        allow(logger).to receive(:error)

        expect { subject.process }.to change { Reading.count }
      end
    end
  end
end
