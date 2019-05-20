# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

stats = [
  ['5PVGesqoOdBR3Lv1074pbA', 'Firma, Wellhausen, Postfach 10 01 65, 32547'],
  ['RcWPBj1bjYvIyFYqH806-A', 'Vishnu, Kay Kay tower, HSR Layout, 560102'],
  ['pxL8msQy_jVEZyUFXuO_hQ', 'John, Kay Kay tower, HSR Layout, 560102']
]
stats.each do |token, location|
  Thermostat.where(household_token: token, location: location).first_or_create!
end
