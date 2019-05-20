# frozen_string_literal: true

module Api
  module V1
    class ThermostatsController < BaseController
      include ThermostatsHelper
      def post_readings
        if validate_params?
          seq_no = reading_queue.push
          render status: 200, json: {
            'message' => 'Reading successfully saved',
            'sequence_number' => seq_no
          }.to_json
        else
          render status: 422, json: { "message": 'Unprocessable entity' }
        end
      end

      def fetch_reading
        household_reading = household_reading(current_household)
        if household_reading.blank?
          render status: 404, json: {
            "message": 'No reading found'
          }.to_json
        else
          render status: 200, json: household_reading
        end
      end

      def fetch_stats
        stat = household_stat
        if stat.blank?
          render status: 404, json: {
            "message": 'No record found'
          }.to_json
        else
          render status: 200, json: stat.to_json
        end
      end

      private

      def validate_params?
        %i[temperature humidity battery_charge].all? { |s| json_body.key? s }
      end

      def reading_queue
        @reading_queue ||= ReadingEnqueueProcessor.new(json_body)
      end
    end
  end
end
