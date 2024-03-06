class DoctorsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_doctor, only: %i[ show edit update ]
  before_action :my_formhelpers, only: %i[ new create ]
  load_and_authorize_resource

  def index
    if user_signed_in? && current_user.admin?
      @doctors = Doctor.all.order_by_personal_card
    else
      @doctors = Doctor.where.not(doctor_status: "fired").order_by_personal_card
    end
  end

  def show
  end

  def new
    @doctor = Doctor.new
  end

  def edit
    @users_role_doctor = User.doctor_formhelper(@doctor.user_id)
    @specialities = Speciality.formhelper
  end

  def create
    @doctor = Doctor.new(doctor_params)
      if @doctor.save
        redirect_to doctors_url, notice: t('notice.create.doctor')
      else
        render :new, status: :unprocessable_entity
      end
  end

  def update
      if @doctor.update(doctor_params)
        redirect_to doctors_url, notice: t('notice.update.doctor')
      else
        render :edit, status: :unprocessable_entity
      end
  end

  private

    def set_doctor
      @doctor = Doctor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_path
    end

    def doctor_params
      params.require(:doctor).permit(:user_id, :speciality_id, :doctor_photo, :doctor_info, :doctor_status)
    end

    def my_formhelpers
      @users_role_doctor = User.free_users_with_role_doctor
      @specialities = Speciality.formhelper
    end
end
