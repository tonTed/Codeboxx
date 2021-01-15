class Building < ApplicationRecord
    belongs_to  :customer
    has_many    :batteries
    has_many    :buildings_details
    belongs_to  :address
    has_many :interventions

    def loc_building
        "#{address.address} - #{address.city}"
    end
end
