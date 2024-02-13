class PersonalCard < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :last_name, presence: true
  validates :first_name, presence: true
  validates :date_of_birth, presence: true  
end
