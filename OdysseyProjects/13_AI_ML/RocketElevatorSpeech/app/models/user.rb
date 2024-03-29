class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :employee
  has_one :customer

  #Test Jorge Assigning default role
  after_create :assign_default_role
  def assign_default_role
    add_role(:signup)
  end
end
