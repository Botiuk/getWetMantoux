# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend

  before_action :authenticate_user!
  before_action :find_user_personal_card

  rescue_from CanCan::AccessDenied do |_exception|
    redirect_to root_url, alert: t('alert.access_denied')
  end

  private

  def find_user_personal_card
    return unless user_signed_in?

    @card = PersonalCard.where(user_id: current_user.id)
    return if @card.present?

    redirect_to new_personal_card_url
  end
end
