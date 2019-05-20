# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_token

      private

      def current_household
        return @current_household if defined?(@current_household)

        token = json_body[:token]
        @current_household = Thermostat.where(household_token: token).first
      end

      def authenticate_token
        return if json_body['token'] && current_household.present?

        render status: 401, json: { message: 'Invalid Token' }.to_json
      end

      def json_body
        @json_body ||= begin
          if request.post?
            JSON.parse(request.body.read).with_indifferent_access
          else
            get_params.to_h
          end
        end
      end

      def get_params
        params.permit(:token, :seq_no)
      end
    end
  end
end
