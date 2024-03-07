class Review < ApplicationRecord
  belongs_to :user
  belongs_to :doctor
  has_rich_text :recommendation

  validates :review_date, presence: true

  default_scope { order(:review_date, :id) }

  scope :order_by_doctors, -> { joins(:doctor).order('review_date, doctors.speciality_id, doctors.id, id') }

  def self.close_records_ids
    @close_record_ids = Review.joins(:rich_text_recommendation).where.not(rich_text_recommendation: {body: [nil, ""]}).pluck(:record_id)
  end

  def self.reviews_index_admin
    Review.close_records_ids
    Review.unscoped.where(review_date: Date.today..(Date.today+7)).where.not(id: @close_record_ids).order_by_doctors
  end

  def self.reviews_index_doctor(doctor_id)
    Review.close_records_ids
    Review.where(doctor_id: doctor_id, review_date: Date.today..(Date.today+7)).where.not(id: @close_record_ids)
  end

  def self.reviews_index_user(user_id)
    Review.close_records_ids
    Review.where(user_id: user_id, review_date: Date.today..(Date.today+7)).where.not(id: @close_record_ids)
  end

  def self.reviews_medical_card(user_id)
    Review.close_records_ids
    Review.where(user_id: user_id, id: @close_record_ids).reverse_order
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
