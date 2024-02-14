class Review < ApplicationRecord
  belongs_to :user
  belongs_to :doctor
  has_rich_text :recomendation

  validates :review_date, presence: true
end
