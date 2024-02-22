class Review < ApplicationRecord
  belongs_to :user
  belongs_to :doctor
  has_rich_text :recomendation

  validates :review_date, presence: true

  def self.close_records_ids
    @close_record_ids = Review.joins(:rich_text_recomendation).where.not(rich_text_recomendation: {body: [nil, ""]}).pluck(:record_id)
  end

  def self.reviews_index_admin
    Review.close_records_ids
    Review.where.not(id: @close_record_ids).order(:review_date, :doctor_id)
  end

  def self.reviews_index_doctor(doctor_id)
    Review.close_records_ids
    Review.where(doctor_id: doctor_id).where.not(id: @close_record_ids).order(:review_date, :user_id)
  end

  def self.reviews_index_user(user_id)
    Review.close_records_ids
    Review.where(user_id: user_id).where.not(id: @close_record_ids).order(:review_date, :doctor_id)
  end

  def self.reviews_medical_card(user_id)
    Review.close_records_ids
    Review.where(user_id: user_id, id: @close_record_ids).order(:review_date).reverse_order
  end

end
