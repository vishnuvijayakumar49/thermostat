# frozen_string_literal: true

class Thermostat < ApplicationRecord
  has_many :readings
  validates :household_token, uniqueness: true
end
