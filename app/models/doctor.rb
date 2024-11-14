# frozen_string_literal: true

class Doctor < ApplicationRecord
  belongs_to :user
  belongs_to :speciality
  has_one :personal_card, through: :user
  has_many :reviews, dependent: nil

  has_one_attached :doctor_photo
  has_rich_text :doctor_info

  validates :user_id, uniqueness: true

  enum :doctor_status, { working: 0, vacation: 1, fired: 2 }

  def self.active_specialities
    Doctor.where.not(doctor_status: 'fired').group(:speciality_id).pluck(:speciality_id)
  end

  scope :order_by_personal_card, lambda {
    joins(:personal_card).order('personal_cards.last_name, personal_cards.first_name, personal_cards.middle_name')
  }
end
