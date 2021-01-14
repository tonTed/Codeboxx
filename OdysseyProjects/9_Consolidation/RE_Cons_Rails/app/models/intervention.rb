class Intervention < ApplicationRecord
  #belongs_to link to the intervention to other tables, the name of column is the table_id
  # for exemple for :customer the name of the column in the table interventions is customer_id
  belongs_to :customer
  belongs_to :building
  belongs_to :battery, optional: true
  belongs_to :column, optional: true
  belongs_to :elevator, optional: true
  belongs_to :employee, optional: true
  belongs_to :author, class_name: "Employee"    #class name permit to link the author_id to a employee

end
