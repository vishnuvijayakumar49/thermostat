FactoryGirl.define do
  factory :reading do
    thermostat_id 1
    temperature 19.0
    sequence_number 5
    humidity 70
    battery_charge 4.5
  end  
end