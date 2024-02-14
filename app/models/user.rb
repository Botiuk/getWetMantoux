class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  after_initialize :set_default_role, if: :new_record?
  enum :role, { user: 0, doctor: 1, admin: 2 }

  validates :phone, uniqueness: true, format: { with: /\A[+]?\d+\z/ }, length: { in: 6..15 }

  has_one :personal_card
  has_one :doctor

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def set_default_role
    self.role ||= :user
  end
end
