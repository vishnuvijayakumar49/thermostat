# frozen_string_literal: true

module ThermostatsHelper
  def household_reading(houshold)
    key = "#{json_body[:token]}:#{json_body[:seq_no]}"
    entry_enqueued?(key) ? fetch_from_queue(key) : fetch_from_db(houshold)
  end

  def fetch_from_queue(key)
    queued_entry = JSON.parse(REDIS.hmget('reading_queue', key).first)
    queued_entry.except('token', 'seq_no').to_json
  end

  def fetch_from_db(houshold)
    seq_no = json_body['seq_no'].to_i
    entry = houshold.readings.where(sequence_number: seq_no).first
    return unless entry.present?

    entry.attributes.slice('humidity', 'temperature', 'battery_charge').to_json
  end

  def entry_enqueued?(key)
    REDIS.hexists('reading_queue', key)
  end

  def household_stat
    key = json_body[:token]
    REDIS.hmget('stats_queue', key).first
  end
end
