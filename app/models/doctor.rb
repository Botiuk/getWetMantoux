class Doctor < ApplicationRecord
  belongs_to :user
  belongs_to :speciality
  has_one :personal_card, through: :user

end
