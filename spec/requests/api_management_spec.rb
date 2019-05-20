# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Api management', type: :request do
  before(:all) do
    themostat = FactoryGirl.create(:thermostat)
    FactoryGirl.create(:empty_thermostat)
    FactoryGirl.create(:reading, temperature: '25.5',
                                 thermostat_id: themostat.id)
  end
  let(:invalid_params) do
    {
      "token": '5PVGesqoOdBR3Lv1074U3e21',
      "temperature": '19',
      "humidity": '73',
      "battery_charge": '5.5'
    }
  end
  let(:post_params) do
    {
      "token": '5PVGesqoOdBR3Lv1074pbA',
      "temperature": '24',
      "humidity": '71',
      "battery_charge": '6.4'
    }
  end

  let(:get_params) { { "token": '5PVGesqoOdBR3Lv1074pbA', "seq_no": '5' } }

  let(:get_params_1) { { "token": '5PVGesqoOdBR3Lv1074pbA', "seq_no": '1' } }

  let(:wrong_get_params) { { "token": '5PVGesqoOdBR3Lv1074pbA', 'seq_no': 10 } }

  let(:stat_params) { { "token": '5PVGesqoOdBR3Lv1074pbA' } }

  let(:stat_params_1) { { "token": 'R9oVesqoOdBR3Lv1078RwE' } }

  context 'posting the reading with params' do
    it 'should return success status' do
      post '/api/v1/post_readings', params: post_params.to_json
      expect(response.status).to eql(200)
    end

    it 'should return error when invalid params try to post' do
      post '/api/v1/post_readings', params: wrong_get_params.to_json
      expect(response.status).to eql(422)
    end

    it 'should return Unathenticated status' do
      post '/api/v1/post_readings', params: invalid_params.to_json
      expect(response.status).to eql(401)
    end
  end

  context 'get end point for fetching household reading' do
    before { post '/api/v1/post_readings', params: post_params.to_json }

    it 'should return status success and the correct reading' do
      get '/api/v1/fetch_reading', params: get_params
      expect(response.status).to eql(200)
    end

    it 'should return parameter with same value of the posted values' do
      get '/api/v1/fetch_reading', params: get_params_1
      expected = JSON.parse response.body
      expect(expected.dig('temperature')).to eql(post_params.dig(:temperature))
      expect(expected.dig('humidity')).to eql(post_params.dig(:humidity))
    end

    it 'should return parameter with value from table created' do
      get '/api/v1/fetch_reading', params: get_params
      expected = JSON.parse response.body
      expect(expected.dig('temperature')).to eql(25.5)
    end

    it 'should return error status when params with seq_no' do
      get '/api/v1/fetch_reading', params: wrong_get_params
      expect(response.status).to eql(404)
    end
  end

  context 'fetch_stats end point' do
    before { post '/api/v1/post_readings', params: post_params.to_json }

    it 'should return the expected stats' do
      get '/api/v1/fetch_stats', params: stat_params
      expect(response.status).to eql(200)
    end

    it 'should return the expected stats' do
      get '/api/v1/fetch_stats', params: stat_params_1
      expect(response.status).to eql(404)
    end
  end
end
