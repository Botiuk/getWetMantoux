class Doctor < ApplicationRecord
  belongs_to :user
  belongs_to :speciality
  has_one :personal_card, through: :user
  has_many :reviews

  has_one_attached :doctor_photo
  has_rich_text :doctor_info

  validates :user_id, uniqueness: true

  enum :doctor_status, { working: 0, fired: 1, vacation: 2 }

end
