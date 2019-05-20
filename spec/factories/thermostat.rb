# frozen_string_literal: true

FactoryGirl.define do
  factory :thermostat do
    household_token '5PVGesqoOdBR3Lv1074pbA'
    location Faker::Address.city
  end

  factory :empty_thermostat, parent: :thermostat do
    household_token 'R9oVesqoOdBR3Lv1078RwE'
  end
end
