class Employee < ApplicationRecord
  belongs_to :user
  has_many :batteries
  has_many :interventions   #has_many permit to have multiples interventions

  # Method for format how we show in the dropdown form
  def full_name
    "#{first_name} #{last_name}"
  end
end
