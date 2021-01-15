class Battery < ApplicationRecord
    belongs_to :building
    belongs_to :employee
    has_many :columns
    has_many :interventions

    # Method for format how we show in the dropdown form
    def b_format_form
        "#{id} - #{cert_ope}"
    end
end
