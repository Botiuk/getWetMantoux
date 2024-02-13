class PersonalCardsController < ApplicationController  
  before_action :find_user_personal_card 
  skip_before_action :find_user_personal_card, only: %i[ new create ]
  before_action :set_personal_card, only: %i[ show edit update ]

  def index
    if current_user.admin?
      @personal_cards = PersonalCard.all.order(:first_name, :last_name, :middle_name, :date_of_birth)
    else
      @personal_card_id = PersonalCard.where(user_id: current_user.id).pluck(:id)
      redirect_to personal_card_url(@personal_card_id)
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
  end

  def personal_card_params
    params.require(:personal_card).permit(:first_name, :middle_name, :last_name, :date_of_birth, :user_id)
  end

end
