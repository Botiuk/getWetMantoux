class PersonalCardsController < ApplicationController
  skip_before_action :find_user_personal_card, only: %i[ new create ]
  before_action :set_personal_card, only: %i[ show edit update ]
  load_and_authorize_resource

  def index
    if current_user.admin?
      @pagy, @personal_cards = pagy(PersonalCard.all, items: 20)
    else
      @personal_card_id = PersonalCard.where(user_id: current_user.id).pluck(:id)
      redirect_to personal_card_url(@personal_card_id)
    end
  rescue Pagy::OverflowError
    redirect_to personal_cards_url(page: 1)
  end

  def search
    if params[:last_name].blank?
      redirect_to personal_cards_url, alert: t('alert.search.personal_card')
    else
      @pagy, @personal_cards = pagy(PersonalCard.where('lower(last_name) LIKE ?', "%" + params[:last_name].downcase + "%"), items: 20)
      @search_params = params[:last_name]
    end
  rescue Pagy::OverflowError
    redirect_to personal_cards_url(page: 1)
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
