# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]
  load_and_authorize_resource

  def index
    if current_user.admin?
      @pagy, @reviews = pagy(Review.reviews_index_admin, items: 20)
      @my_reviews = Review.reviews_index_user(current_user.id)
    elsif current_user.doctor_on_contract?
      @pagy, @reviews = pagy(Review.reviews_index_doctor(current_user.doctor.id), items: 20)
      @my_reviews = Review.reviews_index_user(current_user.id)
    else
      @pagy, @reviews = pagy(Review.reviews_index_user(current_user.id), items: 10)
    end
  rescue Pagy::OverflowError
    redirect_to reviews_url(page: 1)
  end

  def show; end

  def new
    open_review_for_pair = Review.open_review_for_pair(params[:doctor_id], current_user.id)
    if open_review_for_pair.blank?
      @review = Review.new(doctor_id: params[:doctor_id])
      @doctor = Doctor.find(params[:doctor_id])
      redirect_to specialities_url, alert: t('alert.new.recursion') if @doctor.user_id == current_user.id
    else
      redirect_to reviews_url, alert: t('alert.new.present')
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def edit
    return if @review.recommendation.blank?

    redirect_to reviews_url, alert: t('alert.edit.close')
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @doctor = Doctor.find(@review.doctor_id)
    count = Review.count_doctor_open_reviews(@review.doctor_id, @review.review_date)
    if count < 10
      if @review.save
        redirect_to reviews_url, notice: t('notice.create.review')
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
    if @review.recommendation.blank?
      @review.destroy
      redirect_to reviews_url, notice: t('notice.destroy.review')
    else
      redirect_to reviews_url, alert: t('alert.edit.close')
    end
  end

  def medical_card
    if params[:user_id].present? && current_user.doctor_on_contract?
      @pagy, @reviews = pagy(Review.reviews_medical_card(params[:user_id]), items: 10)
    else
      @pagy, @reviews = pagy(Review.reviews_medical_card(current_user.id), items: 10)
    end
  rescue Pagy::OverflowError
    redirect_to reviews_medical_card_path(page: 1)
  end

  private

  def set_review
    @review = Review.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def review_params
    params.require(:review).permit(:user_id, :doctor_id, :review_date, :recommendation)
  end
end
