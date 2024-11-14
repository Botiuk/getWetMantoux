# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  after_initialize :set_default_role, if: :new_record?
  enum :role, { user: 0, doctor: 1, admin: 2 }

  validates :phone, uniqueness: true, format: { with: /\A[+]?\d+\z/ }, length: { in: 6..15 }

  has_one :personal_card, dependent: nil
  has_one :doctor, dependent: nil
  has_many :reviews, dependent: nil

  default_scope { order(:phone) }

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def set_default_role
    self.role ||= :user
  end

  def self.free_users_with_role_doctor
    doctors_user_id = Doctor.pluck(:user_id)
    User.where(role: 'doctor').where.not(id: doctors_user_id).pluck(:phone, :id)
  end

  def self.doctor_formhelper(user_id)
    User.where(id: user_id).pluck(:phone, :id)
  end

  def doctor_on_contract?
    doctor? && doctor.present? && doctor.doctor_status != 'fired'
  end
end
