class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  def index
    if current_user.admin?
      @reviews = Review.reviews_index_admin
    elsif current_user.doctor?
      @reviews = Review.reviews_index_doctor(current_user.doctor.id)
    else
      @reviews = Review.reviews_index_user(current_user.id)
    end
  end

  def show
  end

  def new
    @review = Review.new(doctor_id: params[:doctor_id])
    @doctor = Doctor.find(params[:doctor_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def edit
    if @review.recomendation.present?
      redirect_to review_url(@review), alert: t('alert.edit.close')
    end
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @doctor = Doctor.find(@review.doctor_id)
    count = Review.count_doctor_open_reviews(@review.doctor_id, @review.review_date)
    if count < 10
      if @review.save
        redirect_to review_url(@review), notice: t('notice.create.review')
      else
        render :new, status: :unprocessable_entity
      end
    else
      redirect_to new_review_path(doctor_id: @review.doctor_id), alert: t('alert.doctor_busy')
    end
  end

  def update
    if @review.update(review_params)
        redirect_to reviews_url, notice: t('notice.update.review')
    else
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @review.recomendation.blank?
      @review.destroy
      redirect_to reviews_url, notice: t('notice.destroy.review')
    else
      redirect_to review_url(@review), alert: t('alert.edit.close')
    end
  end

  def medical_card
    @reviews = Review.reviews_medical_card(params[:user_id])
  end

  private

    def set_review
      @review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
    end

    def review_params
      params.require(:review).permit(:user_id, :doctor_id, :review_date, :recomendation)
    end

end
