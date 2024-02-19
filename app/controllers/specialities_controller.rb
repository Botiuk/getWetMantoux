class SpecialitiesController < ApplicationController
  before_action :set_speciality, only: %i[ edit update destroy ]

  def index
    @specialities = Speciality.all
  end

  def new
    @speciality = Speciality.new
  end

  def edit
  end

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

  def destroy
        @speciality.destroy
        redirect_to specialities_url, notice: t('notice.destroy.speciality')
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
