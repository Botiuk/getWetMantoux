# frozen_string_literal: true

class SpecialitiesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index belonging_doctors]
  before_action :set_speciality, only: %i[edit update belonging_doctors]
  load_and_authorize_resource

  def index
    if user_signed_in? && current_user.admin?
      @pagy, @specialities = pagy(Speciality.all, items: 20)
    else
      active_speciality_ids = Doctor.active_specialities
      @pagy, @specialities = pagy(Speciality.where(id: active_speciality_ids), items: 20)
    end
  rescue Pagy::OverflowError
    redirect_to specialities_url(page: 1)
  end

  def new
    @speciality = Speciality.new
  end

  def edit; end

  def create
    @speciality = Speciality.new(speciality_params)
    if @speciality.save
      redirect_to specialities_url, notice: t('notice.create.speciality')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @speciality.update(speciality_params)
      redirect_to specialities_url, notice: t('notice.update.speciality')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def belonging_doctors
    @pagy, @doctors = pagy(Doctor.where(speciality_id: params[:id]).where.not(doctor_status: 'fired'), items: 12)
  rescue Pagy::OverflowError
    redirect_to specialities_url(page: 1)
  end

  private

  def set_speciality
    @speciality = Speciality.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def speciality_params
    params.require(:speciality).permit(:name, :description)
  end
end
