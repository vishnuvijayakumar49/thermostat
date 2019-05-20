class Reading < ApplicationRecord
  validates :sequence_number, uniqueness: true
end
