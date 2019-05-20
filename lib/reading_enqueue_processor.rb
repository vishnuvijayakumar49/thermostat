# frozen_string_literal: true

class ReadingEnqueueProcessor
  attr_accessor :reading
  attr_reader :token

  def initialize(reading)
    @reading = reading
    @token = reading[:token]
  end

  def push
    fetch_current_seq_number
    update_stat_attributes
    push_to_reading_queue
    reading[:seq_no]
  end

  def push_to_reading_queue
    key = "#{token}:#{reading[:seq_no]}"
    REDIS.hmset('reading_queue', key, reading.to_json)
  end

  def fetch_current_seq_number
    seq_no = REDIS.incrby('sequence_number', 1)
    reading.delete(:token)
    reading.merge!(seq_no: seq_no)
  end

  def update_stat_attributes
    queued = REDIS.hexists('stats_queue', token)
    return update_reading if queued

    REDIS.hmset('stats_queue', token, stat_hash_init)
  end

  def update_reading
    json_reading = REDIS.hmget('stats_queue', token).first
    REDIS.multi do
      reading = JSON.parse json_reading
      new_stat_hash = updated_stats(reading).to_json
      REDIS.hmset('stats_queue', token, new_stat_hash)
    end
  end

  def updated_stats(reading)
    reading.each_with_object({}) do |(param, stats), store_stat|
      store_stat[param] = calculate_stat(stats, param)
    end
  end

  def calculate_stat(previous_stat, param)
    return (previous_stat + 1) if param == 'count'

    prev_max = previous_stat['max']
    prev_min = previous_stat['min']
    float_value = reading[param].to_f
    {
      max: prev_max > float_value ? prev_max : float_value,
      min: prev_min < float_value ? prev_min : float_value,
      total: previous_stat['total'] + float_value
    }
  end

  def stat_hash_init
    humidity = reading[:humidity].to_f
    temp = reading[:temperature].to_f
    charge = reading[:battery_charge].to_f
    {
      count: 1,
      humidity: { max: humidity, min: humidity, total: humidity },
      temperature: { max: temp, min: temp, total: temp },
      battery_charge: { max: charge, min: charge, total: charge }
    }.to_json
  end
end
