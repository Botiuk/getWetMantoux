class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  def index
    @reviews = Review.all
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
    if @review.recomendation.blank?
      @doctor = Doctor.find(@review.doctor_id)
    else
      redirect_to review_url(@review), alert: t('notice.edit.close')
    end
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    if @review.save
        redirect_to review_url(@review), notice: t('notice.create.review')
    else
        render :new, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
        redirect_to review_url(@review), notice: t('notice.update.review')
    else
        render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to reviews_url, notice: t('notice.destroy.review')
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
