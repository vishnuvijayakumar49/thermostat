# frozen_string_literal: true

class ReadingSyncProcessor
  def process
    loop do
      available_entries.each do |k, value|
        REDIS.pipelined do
          create_db_entry(k, value)
          REDIS.hdel('reading_queue', k)
        end
      end
    rescue StandardError => e
      logger.error "Failed write error #{e.inspect}"
    end
  end

  def available_entries
    REDIS.hgetall('reading_queue')
  end

  def create_db_entry(token_key, entry)
    token = token_key.split(':').first
    thermostat = Thermostat.where(household_token: token).first
    attributes = JSON.parse(entry)
    attributes['sequence_number'] = attributes.delete('seq_no')
    thermostat.readings.create!(attributes)
    logger.info "entry: #{attributes} created."
  end

  def logger
    Logger.new($stdout)
  end
end
