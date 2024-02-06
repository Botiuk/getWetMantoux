class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable  
  
  validates :phone, uniqueness: true, format: { with: /\A[+]?\d+\z/ }, length: { in: 6..15 }

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
