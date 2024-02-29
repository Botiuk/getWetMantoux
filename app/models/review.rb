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
    Review.where(review_date: Date.today..(Date.today+7)).where.not(id: @close_record_ids).order(:review_date, :id)
  end

  def self.reviews_index_doctor(doctor_id)
    Review.close_records_ids
    Review.where(doctor_id: doctor_id, review_date: Date.today..(Date.today+7)).where.not(id: @close_record_ids).order(:review_date, :id)
  end

  def self.reviews_index_user(user_id)
    Review.close_records_ids
    Review.where(user_id: user_id, review_date: Date.today..(Date.today+7)).where.not(id: @close_record_ids).order(:review_date, :id)
  end

  def self.reviews_medical_card(user_id)
    Review.close_records_ids
    Review.where(user_id: user_id, id: @close_record_ids).order(:review_date, :id).reverse_order
  end

  def self.count_doctor_open_reviews(doctor_id, review_date)
    Review.close_records_ids
    Review.where(doctor_id: doctor_id, review_date: review_date).where.not(id: @close_record_ids).count
  end

  def self.open_review_for_pair(doctor_id, user_id)
    Review.close_records_ids
    Review.where(doctor_id: doctor_id, user_id: user_id, review_date: Date.today..(Date.today+7)).where.not(id: @close_record_ids).pluck(:id)
  end

end
