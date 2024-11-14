# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def find_user_personal_card
    return unless user_signed_in?

    @card = PersonalCard.where(user_id: current_user.id)
    return if @card.present?

    redirect_to new_personal_card_url
  end
end
