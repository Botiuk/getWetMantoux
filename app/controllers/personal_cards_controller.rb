class PersonalCardsController < ApplicationController
  skip_before_action :find_user_personal_card, only: %i[ new create ]
  before_action :set_personal_card, only: %i[ show edit update ]
  load_and_authorize_resource

  def index
    if current_user.admin?
      @personal_cards = PersonalCard.all.order(:last_name, :first_name, :middle_name, :date_of_birth)
    else
      @personal_card_id = PersonalCard.where(user_id: current_user.id).pluck(:id)
      redirect_to personal_card_url(@personal_card_id)
    end
  end

  def search
    if params[:last_name].blank?
      redirect_to personal_cards_url, alert: t('alert.search.personal_card')
    else
      @personal_cards = PersonalCard.where('lower(last_name) LIKE ?', "%" + params[:last_name].downcase + "%")
      @search_params = params[:last_name]
    end
  end

  def show
  end

  def new
    @personal_card = PersonalCard.new
  end

  def edit
  end

  def create
    @personal_card = PersonalCard.new(personal_card_params)
    @personal_card.user_id = current_user.id
    if @personal_card.save
      redirect_to personal_card_url(@personal_card), notice: t('notice.create.personal_card')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @personal_card.update(personal_card_params)
      redirect_to personal_card_url(@personal_card), notice: t('notice.update.personal_card')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_personal_card
    @personal_card = PersonalCard.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def personal_card_params
    params.require(:personal_card).permit(:first_name, :middle_name, :last_name, :date_of_birth, :user_id)
  end

end
